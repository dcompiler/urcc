require 'stringio'
require_relative '../parser/grammar_rule'
require_relative '../../misc/log'
require_relative "../../ast/decl"
require_relative "../../ast/ast_scope"
require_relative "../../ast/ast_stat"
require_relative "../../ast/ast_expr"

class ModuleParser
  def initialize
    @ast_prog = nil
    @ast_queue = Array.new

    @any_text = SeqRule.new(:line, [Any])
    @ignore_rest = RepRule.new(:line, @any_text)

    pri_type = AltRule.new(:line, [Literal["i64"], Literal["i32"], Literal["i8"], Literal["i1"], Literal["void"], Literal["double"], Literal["float"]])
    pointers = RepRule.new(:line, SeqRule.new(:line, [Literal['*']]), [], lambda {|w| return w[0]!='*'})

    @type = SeqRule.new(:line, [pri_type, pointers]) { |*r| 
        t = GetASTType(r[0].tname, r[1].size)
        @ast_queue << t
    }

    @basic_array_rule = SeqRule.new(:line, [Number, Literal['x'], @type])
    @array_type = SeqRule.new(:line, [Literal["["], RepRule.new(:line, @any_text, ']'), Literal["]"]]) { |*r| 
        a = []
        r[1].each {|e| a << e[0]}
        t = GenArrayType(a)
        @ast_queue << t
    }

    @operant = SeqRule.new(:line, [AltRule.new(:line, [Number, Text])]) {
        |*r| @ast_queue << ToCVarName(r[0])
    }

    getelementptr_index = SeqRule.new(:line, [ Literal[','], @type, @operant]) { |*r|
        op = @ast_queue.pop
        @ast_queue.pop
        op
    }
    getelementptr_body = SeqRule.new(:line, [@array_type, Literal['*'], @operant, RepRule.new(:line, getelementptr_index, ')')]) { |*r|
        name = @ast_queue.pop # pop var
        @ast_queue.pop # pop array type
        idx = r[3]
        raise "unsupported getelementptr index" if idx[0] != 0
        idx.shift
        var = Ast::VarAcc.new(GetVarDecl(name))
        idx.each {|i| 
          if i.is_a? Fixnum
              e = Ast::NumConst.new(i)
          else
              e = Ast::VarAcc.new(GetVarDecl(i))
          end
          var.add_dim(e)
        }
        @ast_queue << Ast::OpExpr.new('&', var)
    }

    @expr_getelementptr_call = SeqRule.new(:line, [Literal["getelementptr"], RepRule.new(:line, @any_text, '('), Literal["("], 
          getelementptr_body , Literal[")"]])

    operator_cmp1 = AltRule.new(:line, [Literal["icmp"]])
    operator_cmp2 = AltRule.new(:line, [Literal["eq"], Literal["ne"], Literal["slt"], Literal["sle"], Literal["sge"], Literal["sgt"]])
    @operator_cmp = SeqRule.new(:line, [operator_cmp1, operator_cmp2]) { |*r|
        case r[1].tname
        when "eq" 
          @ast_queue << "=="
        when "ne" 
          @ast_queue << "!="
        when "slt" 
          @ast_queue << "<"
        when "sle" 
          @ast_queue << "<="
        when "sgt" 
          @ast_queue << ">="
        when "sge" 
          @ast_queue << ">="
        else 
          raise "unknown compare symbol '#{r[1].tname}'"
        end
    }
    @operator_add = SeqRule.new(:line, [Literal["add"], @any_text]) {
        @ast_queue << "+"
    }
    @operator_mul = SeqRule.new(:line, [Literal["mul"], AltRule.new(:line, [Literal["nsw"]])]) {
        @ast_queue << "*"
    }
    @operator_sub = SeqRule.new(:line, [Literal["sub"], AltRule.new(:line, [Literal["nsw"]])]) {
        @ast_queue << "-"
    }
    @operator_div = SeqRule.new(:line, [Literal["sdiv"] ]) {
        @ast_queue << "/"
    }
    @operator_rem = SeqRule.new(:line, [Literal["srem"]]) {
        @ast_queue << "%"
    }
    @operator_fadd = SeqRule.new(:line, [Literal["fadd"]]) {
        @ast_queue << "+"
    }
    @operator_fmul = SeqRule.new(:line, [Literal["fmul"]]) {
        @ast_queue << "*"
    }
    @operator_rule = AltRule.new(:line, [
      @operator_cmp,
      @operator_div,
      @operator_mul,
      @operator_sub,
      @operator_add,
      @operator_rem,
      @operator_fadd,
      @operator_fmul,
    ])

    #@align = SeqRule.new(:line, [Literal["align"], Number])

    @expr_getelementptr = SeqRule.new(:line, [Literal["getelementptr"], RepRule.new(:line, @any_text, '['), getelementptr_body]) {
        @ast_queue << "getelementptr"
    }

    @expr_load = SeqRule.new(:line, [Literal["load"], @type, AltRule.new(:line, [@operant, @expr_getelementptr_call]), @ignore_rest]) {
        @ast_queue << "load"
    }
    @expr_alloca = SeqRule.new(:line, [Literal["alloca"], AltRule.new(:line, [@type, @array_type]), @ignore_rest]) {
        @ast_queue << "alloca"
    }
    
    convert_op = AltRule.new(:line, [Literal["bitcast"], Literal["sext"], Literal["sitofp"], Literal["fptosi"]])
    @expr_convert = SeqRule.new(:line, [convert_op, @type, @operant, Literal["To"], @type]) {
        @ast_queue << "convert"
    }
    @expr_op2 = SeqRule.new(:line, [@operator_rule, @type, @operant, Literal[","], @operant]) {
        @ast_queue << "op2"
    }

    call_func_par_rule = SeqRule.new(:line, [@type, AltRule.new(:line, [@operant, @expr_getelementptr_call])]) {
        t, v = @ast_queue.pop(2)
        if v.is_a? Ast::OpExpr # getelementptr
          @ast_queue << v
        else
          @ast_queue << GetVarAcc(v)
        end
    }
    call_func_pars_rule = AltRule.new(:line, [ 
        SeqRule.new(:line, [Literal[")"], @ignore_rest]), 
        SeqRule.new(:line, [call_func_par_rule, RepRule.new(:line, SeqRule.new(:line, [Literal[","], call_func_par_rule]), ")"), Literal[")"], @ignore_rest])
    ])
    @call_func_rule = SeqRule.new(:line, [ Text, Literal["("], call_func_pars_rule]) {|*r| @call_func_name = r[0][1..-1]}

    @expr_call = SeqRule.new(:line, [Literal["call"], @type, RepRule.new(:line, @any_text, "@"), @call_func_rule]) {
        @ast_queue << "call"
    }
    
    @expr_rule = AltRule.new(:line, [
      @expr_load,
      @expr_alloca,
      @expr_convert,
      @expr_call,
      @expr_op2,
      @expr_getelementptr,
    ])

    @stmt_assign = SeqRule.new(:line, [Text, Literal["="], @expr_rule]) { |*r|
        name = ToCVarName(r[0])
        op_type = @ast_queue.pop
        case op_type
        when "convert"
            type = @ast_queue.pop
            val = @ast_queue.pop
            rhs = GetVarAcc(val)
        when "alloca"
            type = @ast_queue.shift
            rhs = nil
        when "load"
            s_type = @ast_queue.shift
            s_var = @ast_queue.shift
            s_decl = GetVarDecl(s_var)
            if s_var.is_a? Ast::OpExpr # getelementptr
              type = s_type
              rhs = s_var
            elsif s_decl.is_a? Decl::Var and s_decl.var_type.is_a? Decl::PrimType
              type = GetPointToType(s_type)
              if s_type != s_decl.var_type
                raise "mismatched type" if type != s_decl.var_type
                rhs = Ast::VarAcc.new(s_decl)
              else
                rhs = Ast::DerefAcc.new(s_decl, 1)
              end
            else
              raise "unhandled load"
            end
        when "call"
            type = @ast_queue.shift
            rhs = Ast::Call.new(@call_func_name)
            @ast_queue.each {|p|
              raise "wrong paramter" if not p.is_a? Ast::Expr
              rhs.add_param(p)
            }
        when "op2"
            op = @ast_queue.shift
            type = @ast_queue.shift
            o1, o2 = @ast_queue.shift(2)
            rhs = Ast::OpExpr.new(op, GetVarAcc(o1), GetVarAcc(o2))
        when "getelementptr" 
            rhs = @ast_queue.shift  
            acc = rhs.rand1
            if acc.var.var_type.is_a?Decl::ArrayType 
              if acc.dim == acc.var.var_type.num_dim
                type = Decl::PrimType.get_prim_type(acc.var.var_type.elem_type.type_name, 1)
              else
                raise "unhandled getelementptr"
              end
            else
              raise "unhandled getelementptr"
            end
        else
            raise "unknown assign stmt"
        end
        decl = Decl::Var.new(name, type)
        @ast_func.add_sym(decl)
        lhs = Ast::VarAcc.new(decl)
        @ast_func.add_child(Ast::AssignStat.new(rhs, lhs)) if rhs
        @ast_queue.clear
    } 
    #store
    store_src_target = SeqRule.new(:line, [@type, AltRule.new(:line, [@operant, @expr_getelementptr_call])])
    @stmt_store = SeqRule.new(:line, [Literal["store"], store_src_target, Literal[","], store_src_target, @ignore_rest]) {
        s_type = @ast_queue.shift
        s_var = @ast_queue.shift
        t_type = @ast_queue.shift
        t_var = @ast_queue.shift

        if s_var.is_a? Ast::OpExpr 
          raise "incorrect store source" if not s_var.rand1.is_a? Ast::VarAcc
          src = s_var
          #src.detach_me
        else
          src = GetVarAcc(s_var)
        end

        t_decl = GetVarDecl(t_var)
        if t_decl.is_a? Decl::Var and t_decl.var_type.is_a? Decl::PrimType
            if GetPointToType(t_type) == t_decl.var_type
              raise "mismatched type" if s_type != t_decl.var_type
              tgt = Ast::VarAcc.new(t_decl)
            elsif t_type == t_decl.var_type
              tgt = Ast::DerefAcc.new(t_decl, 1)
            else
              raise "mismatched type"
            end
        elsif t_var.is_a? Ast::OpExpr # getelementptr
          raise "incorrect store target" if not t_var.rand1.is_a? Ast::VarAcc
          tgt = t_var.rand1
        else
          raise "unhandled store"
        end
        
        print src.c_dump, tgt.c_dump
        @ast_func.add_child(Ast::AssignStat.new(src, tgt))
        @ast_queue.clear
    }
    #label
    @stmt_label = SeqRule.new(:line, [Label] ) { |r|
        @ast_func.add_child( Ast::LabelStat.new(ToCLabelName(r[0..-2]))) 
    } 
    #branch
    br_target = SeqRule.new(:line, [ Literal["label"], Text ]) {|*r| @ast_queue << ToCLabelName(r[1])}
    br_cond = SeqRule.new(:line, [ Literal["i1"], @operant, Literal[","], br_target, Literal[","], br_target])
    @stmt_br = SeqRule.new(:line, [ Literal["br"], AltRule.new(:line, [ br_target,  br_cond ]) ]) {
        if @ast_queue.size == 3
          cond = GetVarAcc(@ast_queue.shift)
          @ast_func.add_child(Ast::GotoStat.new(@ast_queue.shift, cond, @ast_queue.shift))
        else
          raise "wrong br instr" if @ast_queue.size != 1
          @ast_func.add_child(Ast::GotoStat.new(@ast_queue[0]))
        end
        @ast_queue.clear
    }
    #retrun
    @stmt_ret = SeqRule.new(:line, [ Literal["ret"], AltRule.new(:line, [ Literal["void"], SeqRule.new(:line, [@type, @operant]) ])]) { ||
        expr = nil
        expr = GetVarAcc(@ast_queue.pop()) if not @ast_queue.empty? 
        @ast_func.add_child(Ast::ReturnStat.new(expr))
        @ast_queue.clear
    }
    #call
    @stmt_call = SeqRule.new(:line, [@expr_call]) { |*r|
        type = @ast_queue.shift
        @ast_queue.pop #
        rhs = Ast::Call.new(@call_func_name)
        @ast_queue.each {|p|
            raise "wrong paramter #{p}" if not p.is_a? Ast::Expr
            rhs.add_param(p)
        }
        @ast_func.add_child(Ast::AssignStat.new(rhs))
        @ast_queue.clear
    }

    @stmt_rule = AltRule.new(:line, [
      @stmt_label, 
      @stmt_store,
      @stmt_br,
      @stmt_ret,
      @stmt_assign,
      @stmt_call,
    ] )

    func_par_rule = SeqRule.new(:line, [@type, @operant]) {
        t, o = @ast_queue.pop(2)
        @ast_queue << Decl::Var.new(o, t)
    }
    func_par_ignore = SeqRule.new(:line, [Literal["..."]])
    func_pars_rule = AltRule.new(:line, [ SeqRule.new(:line, [Literal[")"]]), 
          SeqRule.new(:line, [func_par_rule, RepRule.new(:line, SeqRule.new(:line, [Literal[","], AltRule.new(:line, [func_par_rule, func_par_ignore])]), ")"), Literal[")"]])
          ]
    )
    @func_name_rule = SeqRule.new(:line, [ Text, Literal["("], func_pars_rule]) {
        |*r| @curr_func_name = r[0][1..-1]
    }

    #@func_attr = AltRule.new(:line, [Literal["noreturn"], Literal["nounwind"], Literal["readonly"], Literal["readnone"]])
    @func_head_rule = SeqRule.new(:line, [ Literal["define"], @type, @func_name_rule, @any_text, Literal["{"] ]) { 
        #NewFuncHeadAction()
        func_ret_type = @ast_queue.shift
        @ast_func = Ast::Func.new(@curr_func_name)
        #func_par_list = 
        func_type = Decl::FuncType.new(func_ret_type)
        @ast_queue.each { |v|
          func_type.add_param(v)
        }
        @ast_func.add_func_type(func_type)
        @ast_prog.add_child(@ast_func)
        @ast_queue.clear
    }

    @func_body_rule = RepRule.new(:file, @stmt_rule, "}" )
    @func_def_rule = SeqRule.new(:file, [ @func_head_rule, @func_body_rule, Literal["}"] ] ) {
        @ast_queue.clear
    }

    func_decl_pars_rule = AltRule.new(:line, [ SeqRule.new(:line, [Literal[")"]]), 
          SeqRule.new(:line, [@type, RepRule.new(:line, SeqRule.new(:line, [Literal[","], AltRule.new(:line, [@type, func_par_ignore])]), ")"), Literal[")"]])
          ]
    )
    func_decl_name_rule = SeqRule.new(:line, [ Text, Literal["("], func_decl_pars_rule]) 
    @func_decl_rule = SeqRule.new(:line, [Literal["declare"], @type, func_decl_name_rule, @ignore_rest])  {
        @ast_queue.clear
    }

    @func_rule = AltRule.new(:file, [@func_def_rule, @func_decl_rule])
    funcs_rule = RepRule.new(:file, @func_rule, "attributes")

    @target_rule = SeqRule.new(:line, [ Literal['target'], RepRule.new(:line, @any_text) ] )
    targets_rule = RepRule.new(:file, @target_rule, ['@', 'define'])

    value_initer = AltRule.new(:line, [ Str, Number, Literal["zeroinitializer"] ])

    @globalvar_rule = SeqRule.new(:line, [ Text, Literal['='], RepRule.new(:line, @any_text, ['constant', 'global']), 
          AltRule.new(:line, [Literal['global'], Literal['constant']]),
          AltRule.new(:line, [@type, @array_type]), value_initer, @ignore_rest]) { |*r|
      name = ToCVarName(r[0])
      type = @ast_queue.pop
      if type.is_a? Decl::ArrayType
          var = Decl::Var.new(name, type)
          @ast_prog.add_sym(var)
      elsif type.is_a? Decl::PrimType
          var = Decl::Var.new(name, type)
          @ast_prog.add_sym(var)
      else
          raise "unhandled glaoble varibale type"
      end
      v = r[-2]
      if v == Literal["zeroinitializer"]
      elsif v.is_a? Fixnum
          rhs = Ast::NumConst.new(v)
      else  
          rhs = Ast::StrConst.new(v)
      end
      @ast_prog.set_initializer(name, rhs)
      @ast_queue.clear
    }
    globalvars_rule = RepRule.new(:file, @globalvar_rule, ['define']) 

    attr_rule = SeqRule.new(:line, [ Literal['attributes'], @ignore_rest] )
    attrs_rule = RepRule.new(:file, attr_rule)

    @module_rule = SeqRule.new(:file, [ targets_rule, globalvars_rule, funcs_rule, attrs_rule] )
  end

  def parse(input)
    @ast_prog = Ast::Scope.new("prog") 
    @module_rule.parse(input) 
    return @ast_prog
  end

  def GenArrayType(t)
      dim = []
      while t[-1].length > 1 and t[-1][-1] == "]"
          t[-1] = t[-1][0..-2]
          n = t.pop # remove the first '['
          #return ArrayType.new(GenArrayType(t), Number.parse(n))
          dim << Number.parse(n)
      end
      # Num x Type
      raise "illegal array type" if t.size!= 3 or t[1]!='x'
      input = Token::Input.new(StringIO.new(t.join(' ')))
      r = @basic_array_rule.parse(input)
      dim << r[0]
      return Decl::ArrayType.new(@ast_queue.pop, dim)
  end

  def GetASTType(llvmtype, ind) 
    type_map = {"i1"=>"bool", "i8"=>"char","i64"=>"short", "i32"=>"int", "i64"=>"long long", 
              "void"=>"void", "double"=>"double", "float"=>"float"}
    raise "unsupported type #{llvmtype}" if not type_map.include? llvmtype
    return Decl::PrimType.get_prim_type(type_map[llvmtype], ind)
  end

  def ToCLabelName(name)
    name = name[1..-1] if name[0] == '%'
    name = name.gsub('.', '_')
    name = 'lbl_' + name
    return name
  end

  def ToCVarName(name)
    return name if name.is_a? Fixnum or name.is_a? Float
    name = name[1..-1] if name[0] == '@'
    name = name[1..-1] if name[0] == '.'
    name = name.gsub('.', '_')
    name = name.gsub('"', '')
    name = name.gsub(' ', '_')
    name[0] = 'var_' if name[0] == '%'
    return name
  end

  def GetPointToType(t) 
    raise "wrong pointer type '#{t}'" if not t.is_a? Decl::Type or t.ind_level == 0
    return Decl::PrimType.get_prim_type(t.type_name, t.ind_level-1)
  end

  def GetVarDecl(name)
    if @ast_func.body.sym_def(name)
      return @ast_func.body.sym_def(name)
    elsif @ast_func.sym_def(name)
      return @ast_func.sym_def(name)
    else
      return @ast_prog.sym_def(name)
    end
  end
  
  def GetVarAcc(var) 
    return Ast::NumConst.new(var) if var.is_a? Fixnum or var.is_a? Float
    d = GetVarDecl(var)
    raise "missing varible '#{var}'" if d == nil
    return Ast::VarAcc.new(d)
  end
end


