require "cfg/cfg"

class TSSAPass 
    attr_reader :cfg

    def initialize(cfg)
        @cfg = cfg

        @taskFuncType = Decl::FuncType.new(Decl::PrimType.get_prim_type("void"))
        @taskFuncType.add_param(Decl::Var.new("tid", Decl::PrimType.get_prim_type("int")))
        @taskFuncType.add_param(Decl::Var.new("stack", Decl::PrimType.get_prim_type("void", 1)))

        @cfg.funcInfo.each { |func|
            elim_dead_omega(func)
            gen_stack_var(func)
            fix_omega_offset(func)
            gen_task_func(func)
        }
    end

    def fix_omega_offset(func)
        func.blocks.each { |bb|
            next if bb.join.empty?
            bb.insts.each { |ins|
                next if ins.dead
                if ins.stat.class == Ast::AssignStat and \
                        ins.stat.rhs.class == Ast::Call and \
                        ins.stat.child(0).id == "task_omega"
                    tid = ins.stat.rhs.para_list_copy[0].const
                    offset = func.taskNodes[tid].stack[ins.vdef[0]][0]
                    ins.stat.rhs.add_param(Ast::NumConst.new(offset))
                end
            }
        }
    end
 
    def use_only_in_task? (func, var_name, tid, visit = [])
        return true if func.ssa_vuse[var_name] == nil
        func.ssa_vuse[var_name].each { |ins|
            next if ins.dead or visit.include? ins
            visit.push(ins)
            #print ins.bb.task_begin_offset, ins.bb.insts.index(ins),' ',var_name, "###", ins.stat, "###\n"
            # phi
            if ins.stat == nil
                return false if not use_only_in_task?(func, ins.vdef_name(0),tid, visit)
            else
                atid = (ins.bb.insts.index(ins) < ins.bb.task_begin_offset) ? 0 : ins.bb.tid
                return false if atid != tid
            end
        }
        return true
    end
  
    def define_in_local_task? (func, var_name, tid)
        ins = func.ssa_vdef[var_name][0]
        if ins.stat 
            atid = (ins.bb.insts.index(ins) < ins.bb.task_begin_offset) ? 0 : ins.bb.tid
        else
            atid = ins.bb.tid
        end
        return atid == tid
    end
 
    def gen_stack_var(func)
        func.taskNodes.each_value { |t|
            t.stack = Hash.new
            t.stack_writes = []
            offset = 0
            rd_var = []
            wr_var = [] 
            insts = t.insts[t.task_begin_offset..-1]
            t.children.each {|c| insts += c.insts }
            insts.each { |ins|
                #next if ins.dead
                raise "no omega after begin" if ins.idx == -1
                ins.vuse.each_index { |idx|
                    var_name = ins.vuse_name(idx)
                    if func.ssa_vdef.key? var_name and not define_in_local_task?(func, var_name, t.tid)
                        rd_var.push(ins.vuse[idx])
                    end
                }
                ins.vdef.each_index { |idx|
                    var_name = ins.vdef_name(idx)
                    if not use_only_in_task?(func, var_name, t.tid)
                        wr_var.push(ins.vdef[idx])
                        t.stack_writes.push(var_name)
                        break
                    end
                }
            }
            rd_var.uniq!
            wr_var.uniq!
            
            rd_var.each {|r|
                t.stack[r] = [offset, 0]
                offset += var_size(r)
            }

            wr_var.each {|w|
                if t.stack.key?(w)
                    t.stack[w][1] = 2
                else
                    t.stack[w] = [offset,1] 
                    offset += var_size(w)
                end
            }

            t.stack_size = offset
            #t.stack.each { |k, v|
            #    print k.c_dump, ' ', v[0], ' ', v[1], "\n"
            #}
        }
    end

    def gen_task_func(func)

        # TODO fix global task id

        func.taskNodes.each { |tid, bb|
            func_name = "URCC_Task#{tid}"

            # insert task_init call
            callStat = Ast::AssignStat.new(Ast::Call.new("task_init"))
            callStat.rhs.add_param(Ast::NumConst.new(tid))
            callStat.rhs.add_param(Ast::OpExpr.new("&", Ast::VarAcc.new(Decl::Var.new(func_name, Decl::PrimType.get_prim_type("int", 0)))))
            callStat.rhs.add_param(Ast::NumConst.new(0))
            callStat.rhs.add_param(Ast::NumConst.new(bb.stack_size))
            callStat.insert_me("before", func.insts[0].stat)

            # create new task function
            taskFunc = Ast::Func.new(func_name, @taskFuncType)
            taskFunc.insert_me("before", func.func)

            vdef = Hash.new

            # move insts to the task function
            sym = []
            start = 0
            insts = []
            ([bb] + bb.children).each { |n| insts += n.insts }
            insts.each {|ins|
                break if ins.stat.class == Ast::AssignStat and \
                        ins.stat.rhs.class == Ast::Call and \
                        ins.stat.child(0).id == "task_begin"
                start += 1
            }
            insts[start+1..-1].each { |ins|
                #ins.dead = true
                ins.stat.detach_me
                #ins.stat.insert_me("childof", taskFunc.body)
                taskFunc.add_child(ins.stat)
                sym |= ins.vuse
                sym |= ins.vdef
                if not ins.vdef.empty?
                    if vdef[ins.vdef[0]]== nil
                        vdef[ins.vdef[0]] = [ins]
                    else
                        vdef[ins.vdef[0]].push(ins)
                    end
                end
            }
            # create symbols
            taskFunc.body.add_sym(sym)
            
            # insert stack load and store
            task_stack = @taskFuncType.param_list_copy[1]
            bb.stack.each { |var, v|
                offset, type = v
                stat = nil
                # type: 0 read only 2: rd/wr
                if type==0 or type==2 
                    stat = ld_wr_stack_stat(task_stack, offset, var, true)
                    stat.insert_me("before", taskFunc.body.child(0))
                    stat = wr_next_stack_stat(tid, offset, var)
                    stat.insert_me("before", bb.insts[start].stat)
                end
            }
            bb.stack_writes.each { |var_name|
                wr_ins = func.ssa_vdef[var_name][0]
                var = wr_ins.vdef[0]
                offset = bb.stack[var][0]
                stat = ld_wr_stack_stat(task_stack, offset, var, false)
                stat.insert_me("after", wr_ins.stat)
            }
        }
    end

    def wr_next_stack_stat(tid, offset, var)
        stat = Ast::AssignStat.new(Ast::Call.new("wr_next_stack"))
        stat.rhs.add_param(Ast::NumConst.new(tid))
        stat.rhs.add_param(Ast::NumConst.new(offset))
        stat.rhs.add_param(Ast::VarAcc.new(var))
        return stat
    end


    def ld_wr_stack_stat(stack, offset, var, ld)
        stat = Ast::AssignStat.new(Ast::Call.new( (ld==true) ? "rd_stack" : "wr_stack"))
        stat.rhs.add_param(Ast::VarAcc.new(stack))
        stat.rhs.add_param(Ast::NumConst.new(offset))
        stat.rhs.add_param(Ast::VarAcc.new(var))
        stat.add_child(Ast::VarAcc.new(var)) if ld == true
        return stat
    end

    def var_size(var)
        return 8 if var.var_type.is_pointer?
        case var.var_type.c_dump
        when "char ", "int ", "long int "
            return 4
        else
            raise "URCC: unknown type " + var.var_type.c_dump 
        end
    end

    def elim_dead_omega(func)
        # save a local copy of vuse
        ssa_vuse = func.ssa_vuse
        workList = []

        func.blocks.each { |bb|
            bb.join.each {|t|
                dead_all = true
                bb.insts.each { |ins|
                    if ins.stat.class == Ast::AssignStat and ins.stat.rhs.class == Ast::Call and \
                        ins.stat.child(0).id == "task_omega" and ins.stat.rhs.para_list_copy[0].const == t.tid
                        #if not local_task_var?(func, ins.vdef_name(0), t.tid)
                        if func.ssa_vuse.key?(ins.vdef_name(0))
                            dead_all = false
                        else
                            #vuse_name = ins.vuse_name(0)
                            #func.ssa_vuse[vuse_name].delete(ins)
                            # delete unused phi function
                            #if func.ssa_vdef[vuse_name].empty? and func.ssa_vdef[vuse_name][0].stat == nil
                            #func.ssa_vuse.key
                            workList.push(ins)
                        end
                    end
                }
                # remove task_join if all omega functions are dead
                if dead_all
                    bb.insts.each { |ins|
                        if ins.stat.class == Ast::AssignStat and ins.stat.rhs.class == Ast::Call and\
                            ins.stat.child(0).id == "task_join" and ins.stat.rhs.para_list_copy[0].const == t.tid
                            #ins.dead = true
                            workList.push(ins)
                            break
                        end
                    }
                    bb.join.delete(t)
                end
            }
        }

        while not workList.empty?
            ins = workList.pop
            ins.dead = true
            ins.vuse.each_index { |idx|
                vuse_name = ins.vuse_name(idx)
                func.ssa_vuse[vuse_name].delete(ins)
                if not func.ssa_vuse[vuse_name].empty? 
                    def_ins = func.ssa_vdef[vuse_name][0]
                    if (def_ins.stat.class == Ast::AssignStat and def_ins.stat.rhs.class == Ast::Call and \
                        def_ins.stat.child(0).id == "task_omega") #or def_ins.stat == nil
                        workList.push(def_ins)
                    end
                end
            }
        end 
    end
end
