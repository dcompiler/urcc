#!/usr/bin/ruby

# Ast::Stat, including AssignStat, GotoStat, LabelStat, and ReturnStat.
# Ast::Expr, including Call, VarAcc, OpExpr, Const
# 
# See StatTests.run for example uses.
#
# Author:: Chen Ding
# Created:: Feb. 8, 2009

require_relative "./ast_tree.rb"
require_relative "./ast_expr.rb"

module Ast

  # The root of all statment classes
  class Stat < Node
    def c_dump(level=0)
      return "  " *level
    end
  end

  class AssignStat < Stat

    # The two children are in the order of RHS and LHS.  It is the
    # order of evaluation.  Also it is an expression statement when
    # 2nd child (LHS) does not appear.
    def initialize(rht, lft=nil)
      if lft == nil
        super("expr_stat")
      else
        super("assign_stat")
      end
      RUtils::expect(rht, Expr, "RHS")
      add_child(rht)
      if lft != nil
        RUtils::expect(lft, VarAcc, "LHS")
        add_child(lft)
      end
      return nil
    end

    def lhs
      return children[1]
    end

    def rhs
      return children[0]
    end

    def c_dump(level=0)
      result = super(level)
      result += "#{lhs.c_dump} = " if lhs != nil
      result += "#{rhs.c_dump};\n"
    end
  end

  class GotoStat < Stat
    attr_reader :target

    # If conditional go-to, the child is the conditonal expression.
    def initialize(target_true_label, condition=nil, target_false_label=nil)
      if condition == nil
        super("goto_stat")
      else
        super("conditional_goto")
      end
      RUtils::expect(target_true_label, String, "target label")
      @target_true = target_true_label
      @target_false = target_false_label
      if condition != nil
        RUtils::expect(condition, Expr, "Go-to condition")
        add_child(condition)
      else
        @target = @target_true
      end
    end

    def condition
      return children[0]
    end

    def c_dump(level=0)
      result = super(level)
      result += "if (#{condition.c_dump}) " if condition != nil
      result += "goto #{@target_true};"
      result += " else goto #{@target_false};" if condition != nil
      result += "\n" 
    end
  end

  class LabelStat < Stat
    attr_reader :label

    # Label;
    def initialize(label)
      super()
      RUtils::expect(label, String, "Label")
      @label = label
    end

    def c_dump(level=0)
      return super(level)+"#{@label}:;\n"
    end
  end

  class ReturnStat < Stat
    # return Expr
    def initialize(expr=nil)
      super()
      if expr != nil then
        RUtils::expect(expr, Expr, "return expression")
        add_child(expr)
      end
    end

    def expr
      return children[0]
    end

    def c_dump(level=0)
      if expr == nil then
        return super(level)+"return;\n"
      else
        return super(level)+"return #{expr.c_dump};\n"
      end
    end
  end
end
