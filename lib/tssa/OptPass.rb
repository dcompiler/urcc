class OptPass
	attr_reader :cfg

	def initialize(cfg)
		@cfg = cfg

		@cfg.funcInfo.each { |func|
			opt(func)
		}
	end

	def opt(func)
		dead_code_elim(func)

		return if func.ssa_vdef == nil

		ssa_opt(func)

		remove_phi(func)

		block_opt(func)
	end

	def block_opt(func)
		func.insts.each_index { |i| inst = func.insts[i]
			next if inst.stat.class != Ast::GotoStat

			inst.dead = true if inst!=func.insts.last and func.labels[inst.stat.target] == func.insts[i+1]

			if inst.dead
				label_inst = func.labels[inst.stat.target]
				label_inst.val -= 1
				label_inst.dead = true if label_inst.val == 0
			end
		}
	end

	def ssa_opt(func)
		# SSA based optimizations
		#
		# 1 const propagation
		# 2 const folding
		# 3 const conditional
		# 4 copy propagation

		workList = Array.new
		func.ssa_vdef.each { |var, v| workList |= v }
		func.ssa_vuse.each { |var, v| workList |= v }

		while not workList.empty? 
			inst = workList.pop
			next if inst.dead
			
			s = inst.stat
			v = inst.eval_expr

			if (v!=nil and s == nil) \
				or (v!=nil and s.class == Ast::AssignStat and !inst.vdef.empty? and !func.isArray(inst.vdef[0]))
				inst.vconst[inst.vdef_name(0)] = v
				inst.val = v
				inst.dead = true
				func.ssa_vuse[inst.vdef_name(0)].each{ |i|
					if not i.vconst.key?(inst.vdef_name(0))
						i.vconst[inst.vdef_name(0)] = v
						i.dead = false
						workList.push(i)
					end
					#i.vconst[inst.vdef_name(0)] = v
					#workList.push(i)
				}
			elsif s.class == Ast::GotoStat 
				inst.val = v
				#inst.vdef = [s.target] if v == true
				inst.dead = true if v == false
			end
		end

		func.ssa_vdef.each { |var, v| workList |= v }
		func.ssa_vuse.each { |var, v| workList |= v }

		while not workList.empty? 
			inst = workList.pop
			next if inst.dead
			
			s = inst.stat
			# x = y
			if (s.class == Ast::AssignStat and s.rhs.class == Ast::VarAcc \
				and !func.isArray(inst.vdef[0]) and !func.isArray(inst.vuse[0]))
				func.ssa_vrepl[inst.vdef_name(0)] = [inst.vuse[0], inst.vusei[0]]
				inst.dead = true
			# x = phi(y)
			elsif s == nil
				c = 0
				idx = nil
				inst.vuse.each_index {|i| 
					if inst.vuse[i]!=nil 
						c = c + 1
						idx = i
					end
				}
				if c == 1 
					func.ssa_vrepl[inst.vdef_name(0)] = [inst.vuse[idx], inst.vusei[idx]]
					inst.dead = true
				end
			end
		end

		func.ssa_vrepl.each { |k, v| workList.push(k)}
		dummy = FuncInfo::Instruction.new(-1)
		while not workList.empty?
			oname = workList.pop
			v = func.ssa_vrepl[oname]
			nname = dummy.gen_ssa_name(v[0].var_name, v[1])
			if func.ssa_vrepl.key?(nname)
				func.ssa_vrepl[oname] = func.ssa_vrepl[nname] 
				func.ssa_vrepl.each {|k ,v| workList.push(k) if dummy.gen_ssa_name(v[0].var_name, v[1])==oname}
			end
		end
	end

	def remove_phi(func)
		new_blocks = Array.new
		func.blocks.each { |bb|
			bb.phi_insts.each { |phi|
				next if phi.dead
				phi.vuse.each_index { |i|
					next if phi.vuse[i] == nil
					nstat = Ast::AssignStat.new(Ast::VarAcc.new(phi.vuse[i]), Ast::VarAcc.new(phi.vdef[0]))
					ninst = FuncInfo::Instruction.new(-1, nstat, bb)
					func.insert_def_rand(ninst, nstat.lhs)
					ninst.vdefi[0] = phi.vdefi[0]
					func.insert_rand(ninst, nstat.rhs)
					ninst.vusei[0] = phi.vusei[i]
					ninst.vconst = phi.vconst
					ninst.replace_rand(nstat.rhs)
					next if ninst.vdef[0]==ninst.vuse[0] and not ninst.vconst.key?(ninst.vuse_name(0))

					last = bb.in[i].insts.last
					last = bb.in[i].insts[-2] if last.dead
					# last is a phi inst or is not a goto
					# so just insert it as new last
					if last == nil or last.stat.class != Ast::GotoStat
						bb.in[i].tail_insts.push(ninst)
					else
						jump_to_bb = (bb.insts[0].stat.class == Ast::LabelStat \
								and bb.insts[0].stat.label == last.stat.target)
						# unconditional goto
						# insert before last
						if last.stat.condition == nil
							bb.in[i].tail_insts.push(ninst)
						# conditional goto but with a const value
						elsif last.val == true and jump_to_bb
							tbb = func.labels[last.stat.target].bb
							ninst.bb = tbb
							tbb.tail_insts.push(ninst)
						# conditional goto
						elsif last.val == nil and jump_to_bb
							if last.vdef.empty?	
								# set a new block to store phi
								newbb = FuncInfo::BasicBlock.new(func)
								newbb.name = func.func.id + "_SSA_#{new_blocks.size}"
								label = "URCC_ssa_label_#{new_blocks.size}"
								last.vdef = [label]
								label_stat = Ast::LabelStat.new(label)
								label_inst = FuncInfo::Instruction.new(-1, label_stat, newbb)
								label_inst.val = 1
								func.labels[last.val] = label_inst
								newbb.head_insts.push(label_inst)
								ninst.bb = newbb
								newbb.head_insts.push(ninst)
								goto_stat = Ast::GotoStat.new(last.stat.target)
								goto_inst = FuncInfo::Instruction.new(-1, goto_stat, newbb)
								goto_inst.vconst = last.vconst
								newbb.head_insts.push(goto_inst)
								new_blocks.push(newbb)
							else
								tbb = func.labels[last.vdef[0]].bb
								ninst.bb = tbb
								tbb.tail_insts.push(ninst)
							end
						else
							bb.head_insts.push(idx, ninst)
						end
					end
				}
				phi.dead = true
			}
		}
		new_blocks.each {|b| func.blocks.push(b)}
	end

	def dead_code_elim(func)
		# save a local copy of vuse
		ssa_vuse = func.ssa_vuse

		workList = Array.new
		func.ssa_vdef.each { |var, a| workList.push(var) }
		while not workList.empty? 
			v = workList.pop
			if func.ssa_vdef.key?(v) and ((not ssa_vuse.key?(v)) or ssa_vuse[v].empty? )
				inst = func.ssa_vdef[v][0]
				next if inst.dead
				if (inst.stat == nil) || (inst.stat.class == Ast::AssignStat and inst.stat.rhs.class != Ast::Call)
					inst.dead = true
					i = 0
					while i < inst.vuse.size
						var = inst.vuse_name(i)
						ssa_vuse[var].delete(inst)
						workList.push(var)
						i += 1
					end
				end
			end
		end
	end

end

