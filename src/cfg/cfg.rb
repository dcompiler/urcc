require "ast/decl.rb"
require "ast/ast_scope.rb"
require "ast/ast_stat.rb"
require "ast/ast_expr.rb"

# function information
class FuncInfo 

	class Instruction
		attr_reader :idx
		attr_accessor :stat	# nil : a phi inst or goto (if val is string)
		attr_accessor :val	# const value for the whole inst
		attr_accessor :bb
		attr_accessor :rmap	# rand to var index map
		attr_accessor :vdef	# variables defined by this inst
		attr_accessor :vuse	# variables referenced by this inst
		attr_accessor :vdefi	# SSA index
		attr_accessor :vusei	# SSA 
		attr_accessor :vconst	# SSA const value
		attr_accessor :dead 

		def initialize(index, statement=nil, block=nil)
			@idx = index
			@stat = statement
			@bb = block
			@rmap = Hash.new
			@vdef = Array.new
			@vuse = Array.new
			@vdefi = Array.new
			@vusei = Array.new
			@vconst = Hash.new
			@dead = false
			@val = nil
		end

		def eval_val(v)
			if v.class == Ast::VarAcc and v.dim==0 and @rmap.key?(v)
				i = @rmap[v]
				var_name = i>0 ? vuse_name(i-1) : vdef_name(-i)
				return @vconst.key?(var_name) ? @vconst[var_name] : nil
			elsif v.class == Ast::NumConst
				return v.const
			end
			return nil
		end

		def eval_expr
			if @stat == nil
				return nil if not @vconst.key?(vuse_name(0))
				v = @vconst[vuse_name(0)]
				@vuse.each_index { |i| 
					next if @vuse[i] != nil and i<1
					return nil if (!@vconst.key?(vuse_name(i)) || @vconst[vuse_name(i)]!=v)
				}
				return v
			elsif @stat.class == Ast::AssignStat 
				rhs = @stat.rhs
				if rhs.class == Ast::OpExpr
					v1 = eval_val(rhs.rand1)
					if v1 != nil
						if rhs.is_binary?
							v2 = eval_val(rhs.rand2)
							if rhs.rator == "*" and (v1 == 0 or v2 == 0)
								return 0
							elsif rhs.rator == "/" and (v1 == 0)
								return 0
							end
							return eval "#{v1} #{rhs.rator} #{v2}" if v2!=nil
						else
							return eval "#{rhs.rator} #{v1}"
						end
					end
				elsif rhs.class == Ast::NumConst or rhs.class == Ast::VarAcc
					return eval_val(rhs)
				end
			elsif @stat.class == Ast::GotoStat and @stat.condition != nil
				cond = @stat.condition
				v1 = eval_val(cond.rand1)
				v2 = eval_val(cond.rand2)
				return (eval "#{v1} #{cond.rator} #{v2}") if v1 != nil and v2 !=nil
			end
			return nil
		end

		def gen_ssa_name(name, i)
			return "#{name}_SSA_#{i}"
		end

		def vuse_name(idx)
			return gen_ssa_name(@vuse[idx].var_name, @vusei[idx])
		end

		def vdef_name(idx)
			return gen_ssa_name(@vdef[idx].var_name, @vdefi[idx])
		end

		def ssa_repl_name(name)
			if @bb and @bb.finfo and @bb.finfo.ssa_vrepl.key?(name) 
				var, i = @bb.finfo.ssa_vrepl[name]
				return gen_ssa_name(var.var_name, i)
			end
			return name
		end
            
        def replace_rand(rand)
            idx = rmap[rand]
            if idx != nil and idx > 0
                idx -= 1
                var_name = vuse_name(idx)
                if bb.finfo.ssa_vrepl.key?(var_name)
                    nvar, i = bb.finfo.ssa_vrepl[var_name]
                    vuse[idx] = nvar
                    vusei[idx] = i
                    val = Ast::VarAcc.new(nvar)
                    val.insert_me("before", rand)
                    rand.detach_me
                    rand = val
                    #inst.rmap[val] = idx
                    var_name = vuse_name(idx)
                end
                if vconst.key?(var_name)
                    val = Ast::NumConst.new(vconst[var_name])
                    val.insert_me("before", rand)
                    rand.detach_me
                end
            end
        end

		def c_ssa_dump
			output = @dead==true ? "D " : ""
			output += "#{@val} " if @val
			if @stat
				@vdef.each_index { |i| output += "#{@stat.class == Ast::GotoStat ? @vdef[0] : ssa_repl_name(vdef_name(i))}, " }
				output += " = "
				@vuse.each_index { |i| output += "#{ssa_repl_name(vuse_name(i))} #{@vconst[ssa_repl_name(vuse_name(i))]}, "}
			else
				p = ""
				@vuse.each_index { |i| p += "#{ssa_repl_name(vuse_name(i))} #{@vconst[ssa_repl_name(vuse_name(i))]}, " }
				output += "#{ssa_repl_name(vdef_name(0))} = phi( #{p} )"
			end
			return output
		end
	end


	class BasicBlock
		attr_accessor :finfo
		attr_accessor :name
		attr_accessor :in	# parents
		attr_accessor :out	# children in CFG
		attr_accessor :insts	# array of all insts in this BB
		attr_accessor :phi_insts# array of phi insts in this BB
		attr_accessor :head_insts# array of phi insts in this BB
		attr_accessor :tail_insts# array of phi insts in this BB
		attr_accessor :DEDef	# 
		attr_accessor :DEKill	# 
		attr_accessor :reaches	# 
		attr_accessor :df	# array of dominance frontier
		attr_accessor :doms	# array of blocks dominate this blocks
		attr_accessor :idom	# imediate dom
		attr_accessor :cdoms	# array of children in dominate tree
		attr_accessor :dead

        # T-SSA support
		attr_accessor :tid
        attr_accessor :children  # children task nodes
        attr_accessor :parent  # parent task node
		attr_accessor :parTasks
		attr_accessor :newTasks
        attr_accessor :cumulative
        attr_accessor :join
        attr_accessor :task_begin_offset
        attr_accessor :stack
        attr_accessor :stack_size
        attr_accessor :stack_writes

		def initialize(finfo)
			@dead = false
			@finfo = finfo
			@in = Array.new
			@out = Array.new
			@insts = Array.new
			@DEDef = Array.new
			@DEKill = Array.new
			@reaches = Array.new
			@df = Array.new
			@doms = Array.new
			@cdoms = Array.new
			@idom = nil
			@phi_insts = Array.new 
			@head_insts = Array.new 
			@tail_insts = Array.new 
            @tid = 0
            @task_begin_offset = 0
            @parent = nil
            @children = []
            @parTasks = []
            @newTasks = []
            @cumulative = []
            @join = []
            @stack = nil
            @stack_writes = nil
            @stack_size = 0
		end
	end
	
	attr_reader :name
	attr_reader :func		# function node
	attr_accessor :insts		# instructions in this function
	attr_reader :labels		# label instructions
	attr_reader :blocks		# basic blocks
	attr_reader :vdef		# 
	attr_reader :vuse		# 
	attr_accessor :ssa_vdef		# 
	attr_accessor :ssa_vuse		# 
	attr_accessor :ssa_vrepl
	#attr_reader :ebbs		# extended basic blokcs
	#attr_reader :dfst		# depth-first spanning tree
	attr_reader :funcCall
    attr_reader :taskNodes

	def initialize(func)
		@func = func
		@name = func.id
		@insts = Array.new
		@labels = Hash.new
		@vdef = Hash.new
		@vuse = Hash.new
		@dead_stats = Array.new
		@ssa_vdef = nil
		@ssa_vuse = nil
		@ssa_vrepl = Hash.new
		@blocks = Array.new
		@funcCall = Array.new
        @taskNodes = Hash.new

		build_cfg

		build_def_use

		build_dom_tree

		comp_dom_frontier

		blocks.each {|b|
			#print "#{b.name}.doms = "
			#b.doms.each { |d| print d.name, ' '}
			#print "\n"

			#print "#{b.name}.idom = "
			#print b.idom ? b.idom.name+"\n" : "\n"

			#print "#{b.name}.cdoms = "
			#b.cdoms.each { |d| print d.name, ' '}
			#print "\n"

			#print "#{b.name}.df = "
			#b.df.each { |df| print df.name, ' '}
			#print "\n"

			#print "\n"
		}
	end

	def isVar(v)
		return (v.class == Ast::VarAcc)
	end


	def isConst(v)
		return (v.class == Ast::Const)
	end


	def isArray(v)
		return ((v.class == Ast::VarAcc and v.dim>0) or \
			(v.class == Decl::Var and v.var_type.class == Decl::ArrayType))
	end


	def insert_def_rand(inst, rand)
		if isVar(rand)
			inst.rmap[rand] = -inst.vdef.size
			inst.vdef.push(rand.var)
			inst.vdefi.push(0)
			return true
		else
			return false
		end
	end


	def insert_rand(inst, rand)
		if isVar(rand)
			inst.vuse.push(rand.var)
			inst.vusei.push(0)
			inst.rmap[rand] = inst.vuse.size	
			return true
		else
			return false
		end
	end

	def build_def_use
		insts.each { |inst|
			s = inst.stat
			if s.class == Ast::AssignStat 
				if s.lhs != nil and isVar(s.lhs) 
					insert_def_rand(inst, s.lhs)
					s.lhs.children_copy.each {|c| insert_rand(inst, c)} if isArray(s.lhs)
				end

				rhs = s.rhs
				if rhs.class == Ast::OpExpr
					#print inst.stat.c_dump
					#print s.lhs.var, rhs.rand1.var, "\n"
					insert_rand(inst, rhs.rand1)
					insert_rand(inst, rhs.rand2) if rhs.is_binary?
				elsif rhs.class == Ast::NumConst
				elsif rhs.class == Ast::VarAcc
					insert_rand(inst, rhs)
					rhs.children_copy.each {|i| insert_rand(inst, i)} if isArray(rhs)
				elsif rhs.class == Ast::Call
					rhs.para_list_copy.each {|p| 
						if p.class == Ast::OpExpr and isVar(p.rand1)
							p.rator == "&" ? insert_def_rand(inst, p.rand1) : insert_rand(inst, p.rand1)
							raise "only 2 op parameter is supported" if p.is_binary? 
						else
							insert_rand(inst, p)
						end
					}
				end
			elsif s.class == Ast::GotoStat and s.condition
				c = s.condition
				insert_rand(inst, c.rand1)
				insert_rand(inst, c.rand2) if c.is_binary?
			elsif s.class == Ast::ReturnStat
				insert_rand(inst, s.expr)
			end	
			inst.vdef.each { |u| 
				vdef[u] = Array.new if not vdef.key?(u)
				vdef[u].push(inst)
			}
			inst.vuse.each { |u| 
				vuse[u] = Array.new if not vuse.key?(u)
				vuse[u].push(inst)
			}
		}
	end

	def build_cfg
		# 1. find out all statements
		# 2. store information for label statements
		# 3. find out all blocks' leaders (from goto statements)
		# 4. build blocks in this function according to the CFG algorithm in the text
		# 5. construct edges among blocks
		# 6. construct edges among functions via Ast::Call statement

		# traval the function tree to find out all statements
		func.each_with_level { |l, s|
			case s.class.name
			when "Ast::ReturnStat", "Ast::GotoStat"
				insts.push(Instruction.new(insts.size, s))
			when "Ast::AssignStat"
				inst = Instruction.new(insts.size, s)
				funcCall.push([inst, s.child(0).id]) if s.rhs.class == Ast::Call
				insts.push(inst)
			when "Ast::LabelStat"
				inst = Instruction.new(insts.size, s)
				inst.val = 0
				insts.push(inst)
				labels[s.label]=inst
			#else
			#	raise "Unsupported instruction '#{s.c_dump}' with type #{s.class.name}"
			end
		}

        tid = Hash.new
        tid_max = 0
        tid_stack = [tid_max]
        #tid = 0
		# a leader of a block is a conditional/unconditional goto statement
		# all leaders' inst # is stored in the leaders array
		leaders = Array.new
		leaders.push(0)
		insts.each_index {|i| 
            ins = insts[i]
            tid[ins] = tid_stack.last
            #ins.tid = tid_stack.last
			if ins.stat.class == Ast::GotoStat
				label_inst = labels[ins.stat.target]
				label_inst.val += 1
				leaders.push(label_inst.idx)
				leaders.push(i+1) if i+1<insts.size 
            # T-CFG
			elsif ins.stat.class == Ast::AssignStat and ins.stat.rhs.class == Ast::Call
                if ins.stat.child(0).id == "task_begin"
                    tid_max += 1
                    tid_stack.push(tid_max)
                    tid[ins] = tid_stack.last
                    #ins.tid = tid_stack.last
				    leaders.push(i) 
                elsif ins.stat.child(0).id == "task_end"
                    ins.dead = true
                    tid_stack.pop()
				    leaders.push(i+1) if i+1<insts.size 
                end
            end
		}
		# remove duplicated number and sort line number
		leaders.sort!
		leaders.uniq!

		# build blocks
		leaders.each_index {|i|
			last = (i+1 == leaders.size) ? insts.size-1 : leaders[i+1] - 1
			bb = FuncInfo::BasicBlock.new(self)
			bb.name = func.id + "_" + leaders[i].to_s
            bb.tid = tid[insts[leaders[i]]]
            if bb.tid > 0
                lead_ins = insts[leaders[i]]
                if lead_ins.stat.class == Ast::AssignStat and \
                    lead_ins.stat.rhs.class == Ast::Call and \
                    lead_ins.stat.child(0).id == "task_begin"
                    taskNodes[bb.tid] = bb
                    lead_ins.stat.rhs.add_param(Ast::NumConst.new(bb.tid))
                    #tidVar = Decl::Var.new("URCC_tid_#{bb.tid}", Decl::PrimType.get_prim_type("int", 0))
                    #bb.finfo.func.add_sym(tidVar)
                    #lead_ins.stat.add_child(Ast::VarAcc.new(tidVar))
                else
                    bb.parent = taskNodes[bb.tid]
                    taskNodes[bb.tid].children.push(bb)
                end
            end
			insts[leaders[i]..last].each { |inst| 
				inst.bb = bb 
                #inst.tid = bb.tid
				bb.insts.push(inst) 
			}
			blocks.push(bb)
		}

		# build edges
		blocks.each_index { |i| 
			b = blocks[i]
			if b.insts.last.stat.class == Ast::GotoStat then
				label_inst = labels[b.insts.last.stat.target]
				tb = leaders.index(label_inst.idx)
				b.out.push(blocks[tb])
				blocks[tb].in.push(b)
				# if the leader is conditional goto, then 
				# there is an additional edge to the next statment
				if b.insts.last.stat.condition != nil then
					b.out.push(blocks[i+1])
					blocks[i+1].in.push(b)
				end
			elsif i+1 != blocks.size
				b.out.push(blocks[i+1])
				blocks[i+1].in.push(b)
			end
		}
	end

	def build_dom_tree
		blocks[0].doms = [blocks[0]]
		blocks[0].idom = nil
		blocks[1..-1].each {|b| b.doms = blocks}
		converged = false

		# dom is temprarily used to store blocks dominate b
		while not converged
			converged = true
			blocks[1..-1].each {|b|
				new_dom = b.in[0].doms
				b.in.each {|bin| new_dom = new_dom & bin.doms}
				new_dom = new_dom | [b]
				if new_dom.size != b.doms.size
					converged = false
					b.doms = new_dom
				end
			}
		end

		# compute immediate dominator
		blocks[1..-1].each { |b|
			bin = b
			while not bin.in.empty? 
				bin = bin.in[0]
				if b.doms.include?(bin)
					b.idom = bin
					# b is a child of bin in dom tree
					bin.cdoms.push(b)
					break
				end
			end
		}
	end

	def comp_dom_frontier(b=nil)
		if b == nil
			comp_dom_frontier(blocks[0])
			return
		end
		b.df = Array.new
		# DF_local = {succ of b that are not strctly dominated by b}
		b.out.each { |succ| b.df.push(succ) if succ.idom != b}
		# DF_up = 
		b.cdoms.each { |dchild|
			comp_dom_frontier(dchild)
			#dchild.df.each {|w| b.df.push(w) if w==b or (not w.doms.include?(b))}
			dchild.df.each {|w| b.df.push(w) if w.idom != b}
		}
	end
end


class CFG
	attr_reader :prog
	attr_reader :funcInfo
	attr_reader :funcName

	def initialize(prog)
		# array of all functions' information 
		# each element is a class FuncInfo
		@prog = prog
		@funcInfo = Array.new
		@funcName = Hash.new

		# get all function nodes from prog tree
		prog.each { |f| 
			if f.class == Ast::Func
				finfo = FuncInfo.new(f)
				funcInfo.push(finfo)
				funcName[finfo.func.id] = finfo
			end
		}
	end

	def update_prog
        funcInfo.each { |f| 

		f.blocks.each { |bb|
			
			# set a insert point for head insts
			first_inst = nil
			pos = 0
			if bb.insts.empty?
				first_inst = f.insts.last
			elsif bb.insts[0].stat.class == Ast::LabelStat
				first_inst = bb.insts[0]
				pos = 1
			else
				first_inst = f.blocks[f.blocks.index(bb)-1].insts.last
			end
			bb.head_insts.reverse_each {|inst| inst.stat.insert_me("after", first_inst.stat)}
			bb.head_insts.reverse_each {|inst| bb.insts.insert(pos, inst)}
			if not bb.insts.empty? and bb.insts.last.stat.class == Ast::GotoStat
				pos = -2
				bb.tail_insts.each {|inst| inst.stat.insert_me("before", bb.insts.last.stat)}
			else
				pos = -1
				bb.tail_insts.reverse_each {|inst| inst.stat.insert_me("after", bb.insts.last.stat)}
			end
			bb.tail_insts.each {|inst| bb.insts.insert(pos, inst)}

			bb.insts.each { |inst|
				next if inst.dead

				s = inst.stat
				if s.class == Ast::AssignStat
					s.lhs.children_copy.each {|c| inst.replace_rand(c)} if s.lhs!=nil and f.isArray(s.lhs)
	
					rhs = s.rhs
					if rhs.class == Ast::OpExpr
						inst.replace_rand(rhs.rand1)
						inst.replace_rand(rhs.rand2) if rhs.is_binary?
					elsif rhs.class == Ast::VarAcc
						inst.replace_rand(rhs) if !f.isArray(rhs)
						rhs.children_copy.each {|c| inst.replace_rand(c)
						} if f.isArray(rhs)
					elsif rhs.class == Ast::Call
						rhs.para_list_copy.each {|p|
							if p.class == Ast::OpExpr
								if f.isVar(p.rand1) and p.rator != "&"
									inst.replace_rand(p.rand1)
								end
								raise "only 2 op parameter is supported" if p.is_binary?
							else
								inst.replace_rand(p)
							end
						}
					end
				elsif s.class == Ast::GotoStat and s.condition
					c = s.condition
					inst.replace_rand(c.rand1)
					inst.replace_rand(c.rand2) if c.is_binary?
					c.detach_me
					target = inst.vdef.empty? ? s.target : inst.vdef[0]	
					goto_inst = Ast::GotoStat.new(target, inst.val != true ? c : nil)
					goto_inst.insert_me("before", s)
					s.detach_me
					inst.stat = goto_inst
				elsif s.class == Ast::ReturnStat
					inst.replace_rand(s.expr)
				end
			}
		}
		f.insts.each {|inst| inst.stat.detach_me if inst.dead}
		}
	end

	def c_dump
		output = ""
		@funcInfo.each { |func|
		output += func.func.id + "\n"

		func.blocks.each { |bb|
			output += "\n" + bb.name + " : idom=#{bb.idom ? bb.idom.name : ""}, tid=#{bb.tid}, parTasks="
            bb.parTasks.each {|t| output+="#{t.tid},"}
            output += " newTasks="
            bb.newTasks.each {|t| output+="#{t.tid},"}
            output += " cumulative="
            bb.cumulative.each {|t| output+="#{t.tid},"}
            output += " join="
            bb.join.each {|t| output+="#{t.tid},"}
            output += "\n"
			bb.phi_insts.each { |inst| output += "\t" + inst.c_ssa_dump + "\n" }
			bb.head_insts.each { |inst| output += "\tH " + inst.c_ssa_dump + "\n" }
			bb.insts.each { |inst|
				output += "\t"
				output += inst.stat ? "#{inst.idx} "+ inst.stat.c_dump : inst.c_ssa_dump + "\n"
				output += "\t\t" + inst.c_ssa_dump + "\n" if inst.stat
			}
			bb.tail_insts.each { |inst| output += "\tT " + inst.c_ssa_dump + "\n" }
		}
		}
		return output
	end

	def to_graph
		c_str = ""

		funcInfo.each { |f| 
			c_str += "\tsubgraph cluster_#{f.func.id} {\n\t\tlabel = \"#{f.func.type.decl_c_dump(f.func.id)}\";\n"
			# write the CFG to graph file
			f.blocks.each_index {|i|
				txt = ""
				j = f.blocks[i].insts[0].idx
				f.blocks[i].insts.each { |inst|
				txt = txt + j.to_s + ' ' + inst.stat.c_dump.gsub(/\n/, "\\l").gsub(/"/, "'").gsub(/\\n/, "")
				j += 1
				}
				c_str  += "\t\t\"#{f.blocks[i].name}\" [ shape=box, label = \"#{txt}\"];\n"
			}	
			f.blocks.each { |b|
				b.out.each { |o| c_str += "\t\t#{b.name} -> #{o.name}\n" }
			}
			c_str += "\t}\n\n"
		}

		# write function call to graph file
		funcInfo.each { |f| f.funcCall.each { |c|
			c_str += "\t#{c[0].bb.name} -> #{c[1]}_0\n" if funcName.key?(c[1])
		}}

		return c_str
	end
end
