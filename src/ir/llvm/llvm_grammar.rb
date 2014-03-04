require 'stringio'
require_relative '../parser/grammar_rule'

class ModuleParser
  def initialize

    @any_text = SeqRule.new(:line, [Any])
    @ignore_rest = RepRule.new(:line, @any_text)
    #@type_array = 
    @type = AltRule.new(:line, [Literal["i32"], Literal["i32*"], Literal["i8"], Literal["i8*"], Literal["i8**"], Literal["i8***"], Literal["void"]])

    @operant = AltRule.new(:line, [Number, Text])
    @type_operant = SeqRule.new(:line, [@type, @operant])

    @expr_getelementptr = SeqRule.new(:line, [Literal["getelementptr"], Literal["inbounds"], Literal["("], RepRule.new(:line, @any_text, ")"), Literal[")"]])

    operator_cmp1 = AltRule.new(:line, [Literal["icmp"]])
    operator_cmp2 = AltRule.new(:line, [Literal["eq"], Literal["ne"], Literal["sle"], Literal["sge"]])
    @operator_cmp = SeqRule.new(:line, [operator_cmp1, @any_text])
    @operator_add = SeqRule.new(:line, [Literal["add"], @any_text])
    @operator_mul = SeqRule.new(:line, [Literal["mul"], AltRule.new(:line, [Literal["nsw"]])])
    @operator_sub = SeqRule.new(:line, [Literal["sub"], AltRule.new(:line, [Literal["nsw"]])])
    @operator_div = AltRule.new(:line, [Literal["sdiv"] ])
    @operator_rule = AltRule.new(:line, [
      @operator_cmp,
      @operator_div,
      @operator_mul,
      @operator_sub,
      @operator_add,
    ])

    @align = SeqRule.new(:line, [Literal["align"], Number])

    @expr_load = SeqRule.new(:line, [Literal["load"], @type, @operant, @ignore_rest])
    @expr_alloca = SeqRule.new(:line, [Literal["alloca"], Text, Literal[","], @align])
    @expr_2op = SeqRule.new(:line, [@operator_rule, @type, @operant, Literal[","], @operant])

    func_par_rule = SeqRule.new(:line, [@type, AltRule.new(:line, [@operant, @expr_getelementptr])])
    func_par_ignore = SeqRule.new(:line, [Literal["..."]])
    func_pars_rule = AltRule.new(:line, [ SeqRule.new(:line, [Literal[")"]]), 
          SeqRule.new(:line, [func_par_rule, RepRule.new(:line, SeqRule.new(:line, [Literal[","], AltRule.new(:line, [func_par_rule, func_par_ignore])]), ")"), Literal[")"]])
          ]
    )
    @called_func_rule = SeqRule.new(:line, [ Text, Literal["("], func_pars_rule]) 

    @expr_call = SeqRule.new(:line, [Literal["call"], RepRule.new(:line, @any_text, "@"), @called_func_rule])
    
    @expr_rule = AltRule.new(:line, [
      @expr_load,
      @expr_alloca,
      @expr_call,
      @expr_2op,
    ])

#    @stmt_getelementptr = SeqRule.new(:line, [Text, Literal["="], Literal["getelementptr"], Literal["inbounds"], RepRule.new(:line, @any_text, ['@', '%']), @])

    @stmt_assign = SeqRule.new(:line, [Text, Literal["="], @expr_rule]) 
    #store
    store_target = SeqRule.new(:line, [@type, AltRule.new(:line, [@operant, @expr_getelementptr])])
    @stmt_store = SeqRule.new(:line, [Literal["store"], @type_operant, Literal[","], store_target, @ignore_rest])
    #label
    @stmt_label = SeqRule.new(:line, [Label] ) 
    #branch
    br_target = SeqRule.new(:line, [ Literal["label"], Text ])
    br_cond = SeqRule.new(:line, [ Literal["i1"], @operant, Literal[","], br_target, Literal[","], br_target]) 
    @stmt_br = SeqRule.new(:line, [ Literal["br"], AltRule.new(:line, [ br_target,  br_cond ]) ])
    #retrun
    @stmt_ret = SeqRule.new(:line, [ Literal["ret"], AltRule.new(:line, [ Literal["void"], @type_operant]) ])
    #call
    @stmt_call = @expr_call

    @stmt_rule = AltRule.new(:line, [
      @stmt_label, 
      @stmt_store,
      @stmt_br,
      @stmt_ret,
      @stmt_assign,
      @stmt_call,
    ] ) { print "stmt\n"}

    #@func_par_rule = RepRule.new(:line, @type_operant, ")")
    @func_name_rule = SeqRule.new(:line, [ Text, Literal["("], func_pars_rule]) 
    #@func_attr = AltRule.new(:line, [Literal["noreturn"], Literal["nounwind"], Literal["readonly"], Literal["readnone"]])
    @func_head_rule = SeqRule.new(:line, [ Literal["define"], @type, @func_name_rule, @any_text, Literal["{"] ]) 
    @func_body_rule = RepRule.new(:file, @stmt_rule, "}" )
    @func_def_rule = SeqRule.new(:file, [ @func_head_rule, @func_body_rule, Literal["}"] ] )

    func_decl_pars_rule = AltRule.new(:line, [ SeqRule.new(:line, [Literal[")"]]), 
          SeqRule.new(:line, [@type, RepRule.new(:line, SeqRule.new(:line, [Literal[","], AltRule.new(:line, [@type, func_par_ignore])]), ")"), Literal[")"]])
          ]
    )
    func_decl_name_rule = SeqRule.new(:line, [ Text, Literal["("], func_decl_pars_rule]) 
    @func_decl_rule = SeqRule.new(:line, [Literal["declare"], @type, func_decl_name_rule])
    #@func_decls_rule = RepRule.new(:file, @func_decl_rule, 'define')

    @func_rule = AltRule.new(:file, [@func_def_rule, @func_decl_rule])
    @funcs_rule = RepRule.new(:file, @func_rule)

    @target_rule = SeqRule.new(:line, [ Literal['target'], RepRule.new(:line, @any_text) ] )
    @targets_rule = RepRule.new(:file, @target_rule, ['@', 'define'])

    @globalvar_rule = SeqRule.new(:line, [ Text, Literal['='], RepRule.new(:line, @any_text) ] )
    @globalvars_rule = RepRule.new(:file, @globalvar_rule, ['define']) 

    #@module_rule = @target_rule
    @module_rule = SeqRule.new(:file, [ @targets_rule, @globalvars_rule, @funcs_rule] )
  end

  def parse(input)
    @module_rule.parse(input) 
  end
end

t = ModuleParser.new()
f = File.open(ARGV[0]).read
input = Token::Input.new(StringIO.new(f))
t.parse(input)
