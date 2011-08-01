#!/usr/bin/ruby

# Ast::Scoped, including program, file, and block.  Each has a symbol
# table and an Ast::Node sequence.  The symbol table maps from symbol
# name to a Decl::Var object.
# 
# See ScopeTests.run for example uses.
#
# Author:: Chen Ding
# Created:: Feb. 7, 2009

require "ast/decl.rb"
require "ast/ast_tree.rb"

module Ast

  class Scope < Node
    # uncomment for debugging (normal use through Scope.find_sym)
    # attr_reader :symbols
    
    def initialize(s_nm) 
      super(s_nm)
      @symbols = Hash.new
    end

    # sym may be one Decl::Var or an array or set of them
    def add_sym(sym)
      if sym.is_a?(Decl::Var) 
        add_one_sym(sym)
      elsif sym.is_a?(Array)
        sym.each do |s|
          add_one_sym(s)
        end
      elsif sym.is_a?(Hash)
        sym.each_value do |s|
          add_one_sym(s)
        end
      else
        raise "Symbol type (#{sym.class.to_s}) incorrect\n"
      end
    end

    def sym_def(name)
      return @symbols[name]
    end

    # clear all symbols when name is nil or not provided
    def remove_sym(name=nil)
      if name==nil
        @symbols = Hash.new
      else
        @symbols[name] = nil
      end
    end

    def symbols_copy
      return @symbols.clone
    end

    # A static function, so can be used for symbols unattached to a scope
    def Scope.sym_c_dump(sym, level=0)
      if sym.is_a?(Decl::Var)
        return Scope.one_sym_c_dump(sym, level)
      elsif sym.is_a?(Enumerable)
        result = ""
        sym.each_value do |s|
          result += one_sym_c_dump(s, level)
        end
      else
        raise "Symbol class (#{sym.class.to_s}) incorrect\n"
      end
      return result
    end

    # Only Stat (not Expr) or Scope may be added.  Return true if
    # insertion successful; otherwise false.
    def add_child(stmt)
      # make sure we add only Scope/Stat objects
      raise "Member of Scope can be either Scope or Stat but not #{stmt.class.to_s}\n  " if !stmt.is_a?(Scope) and !stmt.is_a?(Stat)
      super(stmt)
      # integrity checking, currently disabled
      # return true
      # is_succ = stmt.sym_consistent?
      # stmt.detach if !is_succ
      # return is_succ
    end

    def c_dump(level=0)
      result = "  " *(level+1) + "/* #{self.class.to_s} #{@id}: #{@symbols.size} symbols, #{children.size} children */\n"
      result += Scope.sym_c_dump(@symbols, level+1) + "\n"
      children.each do |c|
        result += c.c_dump(level+1)
      end
      return result
    end

    # TODO:: to add deep clone (including symbol table)

    private
    def add_one_sym(sym)
      raise "Symbol type (#{sym.class.to_s}) is not Decl::Var\n" if !sym.is_a?(Decl::Var)
      name = sym.var_name
      raise "Symbol (#{sym.c_dump}) already in #{id}'s table." if @symbols[name]!=nil
      @symbols[name] = sym
    end

    def Scope.one_sym_c_dump(sym, level=0)
      return "  " *level + "#{sym.c_dump};\n"
    end
  end

  # c_dump inside a pair of brackets
  class Block < Scope
    def c_dump(level=0)
      result = "  " *level + "{\n"
      result += super(level+1)
      result += "  " *level + "}\n"
      return result
    end
  end

  # Func is a scope with only its parameters in the symbol table.
  # It has one child, which is a Block---its body.
  class Func < Scope
    attr_reader :type

    def initialize(f_nm, type=nil)
      super(f_nm)
      add_func_type(type) if type!=nil
      add_child(Block.new("#{f_nm} body"))
    end

    def add_func_type(type)
      RUtils::expect(type, Decl::FuncType, "function type")
      raise "Function type (#{type.decl_c_dump(@id)}) already exists\n" if @type!=nil
      @type = type
      add_sym(type.param_list_copy, "parameters")
    end

    def add_sym(sym, type="normal")
      if type=="parameters"
        super(sym)
      else
        body.add_sym(sym)
      end
    end

    # The first add_child adds the body block.  Later ones add to the body.
    def add_child(chd)
      if body==nil
        # called from the constructor
        super(chd)
      else
        return body.add_child(chd)
      end
    end

    def body
      return children[0]
    end

    def c_dump(level=0)
      # reset the level to 0
      if (@type!=nil)
        result = @type.decl_c_dump(@id)
      else # untyped function
        result = "int #{@id}( ) "
      end
      result += body.c_dump
    end
  end
end # module Ast

module ScopeTests

  def run
    prog = Ast::Scope.new("prog")
    file = Ast::Scope.new("file1.c")
    prog.add_child(file)
    main = Ast::Func.new("main")
    main.add_func_type(Decl::FuncType.main_type)
    file.add_child(main)
    print prog.c_dump
  end
  module_function :run
end
    
