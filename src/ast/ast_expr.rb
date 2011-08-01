#!/usr/bin/ruby

# Ast::Expr, including Call, VarAcc, OpExpr, Const
# 
# See ExprTests.run for example uses.
#
# Author:: Chen Ding
# Created:: Feb. 8, 2009

require "misc/utils.rb"
require "ast/ast_tree.rb"

module Ast

  # The root of all expression classes
  class Expr < Node
  end

  # Const is divided into Ast::NumConst and Ast::StrConst
  class Const < Expr
    attr_reader :const
    def c_dump
      return @const.to_s
    end
  end

  class NumConst < Const
    def initialize(num)
      super("numeric const")
      RUtils::expect(num, ::Numeric, "const")
      @const = num
    end
  end

  class StrConst < Const
    def initialize(str)
      super("string const")
      RUtils::expect(str, ::String, "const")
      @const = str
    end

    def c_dump
      return "\"#{const}\""
    end
  end      

  class VarAcc < Expr
    attr_reader :var
    def initialize(var)
      super("var access")
      RUtils::expect(var, Decl::Var, "var access")
      @var = var
    end

    def add_dim(ind_expr)
      RUtils::expect(ind_expr, Expr, "index expression")
      RUtils::expect(var.var_type, Decl::ArrayType, "var type in array access")
      raise "Too many dimensions (#(dim)) for array #{var.c_dump}\n" if dim >= var.var_type.num_dim
      add_child(ind_expr)
    end

    def dim
      return children.size
    end

    def c_dump
      result = var.var_name
      return result if dim == 0
      children.each { |chd| result += "[#{chd.c_dump}]" }
      return result
    end
  end

  class Call < Expr
    def initialize(func_nm)
      super(func_nm)
    end

    def add_type(type)
      RUtils::expect(type, Decl::FuncType, "call func type")
      @func_type = type
    end

    def add_param(expr)
      RUtils::expect(expr, Expr, "call parameter")
      add_child(expr)
    end

    def func_name
      return @id
    end

    def para_list_copy
      return children_copy
    end

    def c_dump
      result = "#{func_name}("
      children.each_with_index do |p, i|
        result += p.c_dump
        result += ", " if i < children.size-1
      end
      return result + ")"
    end
  end

  # One operator and one or two operands.
  class OpExpr < Expr

    def initialize(op, r1, r2=nil)
      RUtils::expect(op, ::String, "rator")
      super(op)
      RUtils::expect(r1, Expr, "rand1")
      add_child(r1)
      if r2 != nil
        RUtils::expect(r2, Expr, "rand2")
        add_child(r2)
      end
    end
        
    def rator
      return @id
    end

    def rand1
      return children[0]
    end

    def rand2
      return children[1]
    end

    def is_unary?
      return rand2==nil
    end

    def is_binary?
      return !is_unary?
    end

    def c_dump
      if is_unary?
        return "(#{rator} #{rand1.c_dump})"
      else
        return "(#{rand1.c_dump} #{rator} #{rand2.c_dump})"
      end
    end
  end
end
