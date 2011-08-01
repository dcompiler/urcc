require "CFG"

class SSAPass
	attr_reader :cfg

	def initialize(cfg)
		@cfg = cfg
		@cfg.funcInfo.each { |func| 
			insert_phi(func)
			insert_join_omega(func)
			rename(func)
			update_name_map(func)
		}
	end

	def update_name_map(func)
		func.ssa_vdef = Hash.new
		func.ssa_vuse = Hash.new
		func.ssa_vrepl = Hash.new
		insts = func.insts.dup
		func.blocks.each {|bb| insts |= bb.phi_insts}
		insts.each { |inst|
			inst.vdef.each_index { |i|
				next if inst.vdef[i].var_type.class == Decl::ArrayType
				v = inst.vdef_name(i)
				raise "SSA shoule not be redefined" if func.ssa_vdef.key?(v)
				func.ssa_vdef[v] = Array.new 
				func.ssa_vdef[v].push(inst)
			}
			inst.vuse.each_index { |i|
				#next if inst.vuse[i].var_type.class == Decl::ArrayType
				v = inst.vuse_name(i)
				func.ssa_vuse[v] = Array.new if not func.ssa_vuse.key?(v)
				func.ssa_vuse[v].push(inst)
			}
		}
	end

	def insert_phi(func)
		func.blocks.each {|bb| bb.phi_insts = Array.new}
		func.vdef.each { |var, insts|
			#next if var.var_type.class == Decl::ArrayType
			next if func.isArray(var)

			everOnWorkList = Array.new
			workList = Array.new
				
			insts.each { |inst|
				everOnWorkList.push(inst.bb)
				workList.push(inst.bb)
			}
				
			everOnWorkList.uniq!
			workList.uniq!

			while not workList.empty?
				bb = workList.pop
				bb.df.each { |dfbb|
					found_in_phi = false
					dfbb.phi_insts.each { |inst|
						if inst.vdef[0] == var
							found_in_phi = true
							break
						end
					}
					if not found_in_phi
						phi_inst = FuncInfo::Instruction.new(dfbb.phi_insts.size, nil, dfbb)
						phi_inst.vdef = Array.new(1, var)
						phi_inst.vdefi = Array.new(1, nil)
						phi_inst.vuse = Array.new(dfbb.in.size, var)
						phi_inst.vusei = Array.new(dfbb.in.size, nil)
						dfbb.phi_insts.push(phi_inst)
						if not everOnWorkList.include?(dfbb)
							everOnWorkList.push(dfbb)
							workList.push(dfbb)
						end
					end
				}
			end
		}
	end

	def insert_join_omega(func)
        # compute ParTasks
        converged = false
        while not converged
            converged = true
            func.blocks[1..-1].each { |blk|
                if blk.parent
                    blk.parTasks = blk.parent.parTasks
                elsif 
                    new_par = []
                    blk.in.each { |bin| 
                        new_par |= bin.parTasks
                        new_par |= [func.taskNodes[bin.tid]] if bin.tid > 0
                    }
                    new_par.uniq!
                    if new_par.size != blk.parTasks.size
                        converged = false
                        blk.parTasks = new_par
                    end
                end
            }
        end

        # compute NewTasks
        func.blocks[1..-1].each { |blk|
            next if blk.parent
            nodes = [blk]
            while not nodes.empty?
                cur = nodes.last
                nodes.pop
                next if cur.in[0]==blk.idom
                cur.in.each { |cin|
                    blk.newTasks.push(func.taskNodes[cin.tid]) if cin.tid > 0
                    nodes.push(cin)
                }
            end
            blk.newTasks.push(func.taskNodes[blk.idom.tid]) if blk.idom.tid > 0
            blk.newTasks.uniq!
        }

        bbvdef = Hash.new
        bbvuse = Hash.new
        func.blocks.each { |bb|
            vdef = []
            vuse = []
            bb.insts.each { |ins|
                vuse|=ins.vuse
                vdef|=ins.vdef
            }
            if bb.parent != nil
            #    bbvdef[bb.parent] = [] if not bbvdef.key? bb.parent
            #    bbvuse[bb.parent] = [] if not bbvuse.key? bb.parent
                bbvdef[bb.parent] |= vdef
                bbvuse[bb.parent] |= vuse
            else
                bbvdef[bb] = vdef
                bbvuse[bb] = vuse
            end
        }

        # compute cumulative
        dom_tree = []
        func.blocks[0].cdoms.each {|c| dom_tree.push([func.blocks[0], c])}
        done = []
        while not dom_tree.empty?
            p, cur = dom_tree.last
            dom_tree.pop
            next if done.include? cur
            done.push(cur)
            if cur.parent == nil
                par_common_var = Hash.new
                # find Join
                cur.parTasks.each { |par|
                    common_var = bbvdef[par] & bbvuse[cur]
                    if cur.tid == par.tid
                        var = []
                        common_var.each { |v|
                            func.vuse[v].each { |i| 
                                if i.bb.tid != cur.tid
                                    var.push(v)
                                    break
                                end
                            }
                        }
                        common_var = var
                    end
                    if not common_var.empty?
                        cur.join.push(par)
                        par_common_var[par] = common_var
                    end
                }

                # TODO recheck use idom or parent in dom tree here?

                # remove unnecessary joins
                #p = cur.idom
                p = func.taskNodes[p.tid] if p.parent
                cur.join = cur.join - (p.cumulative - cur.newTasks)
                cur.cumulative = (p.cumulative - cur.newTasks) | cur.join

                # insert join and omega functions
                cur.join.each { |t|
                    # TODO add a control flow edge from t to n 
                    vdef = par_common_var[t]
                    # insert join function
                    i = 0
                    cur.insts.each {|ins| 
                        break if not (ins.vuse & vdef).empty?
                        i += 1
                    } if cur.tid == 0
                    call_join_func = FuncInfo::Instruction.new(-1, gen_join_function(t.tid), cur)
                    call_join_func.stat.insert_me("before", cur.insts[i].stat)
                    cur.insts.insert(i, call_join_func)
                    #insert omega function
                    vdef.each {|v|
                        i += 1
                        call_omega_func = FuncInfo::Instruction.new(-1, gen_omega_function(t.tid, v), cur)
                        call_omega_func.vdef.push(v)
                        call_omega_func.vuse.push(v)
                        call_omega_func.stat.insert_me("after", call_join_func.stat)
                        cur.insts.insert(i, call_omega_func)
                    }
                    cur.task_begin_offset = i + 1 if cur.tid != 0
                }
            end
            cur.cdoms.each {|c| dom_tree.push([cur, c])}
        end

        func.insts = Array.new
        func.blocks.each {|bb| func.insts+=bb.insts}
    end

    def gen_join_function(tid)
        func = Ast::AssignStat.new(Ast::Call.new("task_join"))
        func.rhs.add_param(Ast::NumConst.new(tid))
        #print func.c_dump
        return func
    end

    def gen_omega_function(tid, varDec)
        func = Ast::AssignStat.new(Ast::Call.new("task_omega"), Ast::VarAcc.new(varDec))
        func.rhs.add_param(Ast::NumConst.new(tid))
        func.rhs.add_param(Ast::VarAcc.new(varDec))
        #print func.c_dump
        return func
    end

	def rename(func)
		@counters = Hash.new
		@stacks = Hash.new
		@finishBB = Array.new
		body_sym = func.func.body.symbols_copy
		func_sym = func.func.symbols_copy
		prog_sym = func.func.parent.symbols_copy
		body_sym.each { |name, sym|
			new_index(sym) if sym.class==Decl::Var
		}
		func_sym.each { |name, sym|
			new_index(sym) if not body_sym.key?(name) and sym.class==Decl::Var
		}
		prog_sym.each { |name, sym|
			new_index(sym) if !body_sym.key?(name) and !func_sym.key?(name) and sym.class==Decl::Var
		}
		rename_block(func.blocks[0])
	end

	def new_index(var)
		if not @counters.key?(var)
			@counters[var] = 0
			@stacks[var] = Array.new
		end
		i = @counters[var]
		@stacks[var].push(i)
		@counters[var] += 1 if var.var_type.class != Decl::ArrayType
		return i
	end

	def get_index(var)
		return @stacks[var].last
		#return @stacks.key?(var) ? @stacks[var].last : 0
	end

	def rename_block(bb)
        #print bb.name
		@finishBB.push(bb)

		# LHS of phi_insts
		bb.phi_insts.each { |inst| inst.vdefi[0] = new_index(inst.vdef[0])}

		bb.insts.each { |inst|
			inst.vusei = Array.new(inst.vuse.size, 0)
			inst.vuse.each_index { |i|
				var = inst.vuse[i]
				idx = get_index(var)
				inst.vusei[i] = idx
			}

			inst.vdefi = Array.new(inst.vdef.size, 0)
			inst.vdef.each_index { |i|
				var = inst.vdef[i]
				idx = new_index(var)
				inst.vdefi[i] = idx
			}
		}

		# rename phi function of bb's succ
		bb.out.each { |succ|
			j = succ.in.index(bb)
            #print succ.name, succ.phi_insts.size
			succ.phi_insts.each { 
                |inst| inst.vusei[j] = get_index(inst.vdef[0]) 
            }
		}

		bb.out.each {|succ| rename_block(succ) if not @finishBB.include?(succ)}
		
		(bb.phi_insts | bb.insts).each {|inst| inst.vdef.each {|var| @stacks[var].pop } }
	end
end
