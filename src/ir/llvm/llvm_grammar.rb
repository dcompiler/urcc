require 'stringio'
require_relative '../parser/grammar_rule'

class ModuleParser
  def initialize

    @type = AltRule.new(:line, [Literal["i32"], Literal["i32*"]])

    @operant = AltRule.new(:line, [Number, Text])
    @type_operant = SeqRule.new(:line, [@type, @operant])

    operator_cmp1 = AltRule.new(:line, [Literal["icmp"]])
    operator_cmp2 = AltRule.new(:line, [Literal["eq"], Literal["ne"], Literal["sle"], Literal["sge"]])
    @operator_cmp = SeqRule.new(:line, [operator_cmp1, operator_cmp2])
    @operator_mul = SeqRule.new(:line, [Literal["mul"], AltRule.new(:line, [Literal["nsw"]])])
    @operator_sub = SeqRule.new(:line, [Literal["sub"], AltRule.new(:line, [Literal["nsw"]])])
    @operator_div = AltRule.new(:line, [Literal["sdiv"] ])
    @operator_rule = AltRule.new(:line, [
      @operator_cmp,
      @operator_div,
      @operator_mul,
    ])

    @align = SeqRule.new(:line, [Literal["align"], Number])

    @expr_load = SeqRule.new(:line, [Literal["load"], @type, @operant, Literal[","], @align])
    @expr_alloca = SeqRule.new(:line, [Literal["alloca"], Text, Literal[","], @align])
    @expr_2op = SeqRule.new(:line, [@operator_rule, @type, @operant, Literal[","], @operant])

    @expr_call = SeqRule.new(:line, [Literal["call"], Text, Literal[","], @align])
    
    @expr_rule = AltRule.new(:line, [
      @expr_load,
      @expr_alloca,
      @expr_call,
      @expr_2op,
    ])

    @stmt_assign = SeqRule.new(:line, [Text, Literal["="], @expr_rule]) {
      |v| print "assign", v, "\n"
    }
    #store
    @stmt_store = SeqRule.new(:line, [Literal["store"], @type_operant, Literal[","], @type_operant, Literal[","], @align])
    #label
    @stmt_label = SeqRule.new(:line, [ Label ] ) {
        |l| print l
    }
    #branch
    label = SeqRule.new(:line, [ Literal["label"], Text ])
    br_cond = SeqRule.new(:line, [ Literal["i1"], @operant, Literal[","], label, Literal[","], @label])
    @stmt_br = SeqRule.new(:line, [ Literal["br"], AltRule.new(:line, [ @label,  br_cond ]) ])
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
    ] )

    @func_attr = AltRule.new(:line, [Literal["noreturn"], Literal["nounwind"], Literal["readonly"], Literal["readnone"]])
    @func_par_rule = RepRule.new(:line, @type_operant, ")")
    @func_name_rule = SeqRule.new(:line, [ Text, Literal["("], @func_par_rule, Literal[")"] ])
    @func_head_rule = SeqRule.new(:line, [ Literal["define"], Text, @func_name_rule, @func_attr, Literal["{"] ]) {
      |ret| print ret
    }
    @func_body_rule = RepRule.new(:file, @stmt_rule, "}" )
    @func_def_rule = SeqRule.new(:file, [ @func_head_rule, @func_body_rule, Literal["}"] ] )
    #@func_decl_rule = SeqRule.new(:line, [ Literal["declare"], @func_head_rule ]
    #@func_rule = AltRule.new(:file, @func_decl_rule, @func_def_rule)
    @func_rule = @func_def_rule
    @funcs_rule = RepRule.new(:file,  @func_def_rule)
    @module_rule = SeqRule.new(:file, [ @funcs_rule ] )
  end

  def parse(input)
    @module_rule.parse(input) 
  end
end

t = ModuleParser.new()
f = File.open(ARGV.argv[0]).read
input = Token::Input.new(StringIO.new(f))
t.parse(input)
