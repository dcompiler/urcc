#!/usr/bin/ruby

# Ast Nodes for data types.  It uses a prim_pool to hold and supply
# all primitive type decl nodes, so each has a "singlton" node.
# 
# To construct a primitive type
#   PrimType.get_type(ind, tname)
#
# To construct a composite type, use individual constructors.
#
# See DeclTests.run for example uses.
#
# Author:: Chen Ding
# Created:: Feb. 7, 2009


module Decl

# BaseType contains the levels of indirection, 0 by default
class Type
  attr_reader :ind_level

  def is_pointer?
    return @ind_level>0
  end

  #private_class_method :new

  # TODO:: Type is added only indirectly through its chidren classes
  def initialize(ind = 0)
    set_indirection(ind)
  end

  protected
  def set_indirection(ind)
    raise "cannot reset previous indirection (#{@ind_level})\n" if @ind_level != nil
    raise "negative indirection (#{ind})\n" if ind<0
    @ind_level = ind
  end
end

class PrimType < Type
  attr_reader :type_name
  
  def PrimType.prim_pool
    return @@prim_pool
  end
  @@prim_pool = Hash.new

  # private_class_method :new

  def initialize(tname, ind=0)
    super(ind)
    @type_name = tname
    key = c_dump
    raise "primitive type #{dumpC} has been defined\n" if @@prim_pool[key]!=nil
    @@prim_pool[key] = self
  end

  def PrimType.c_dump(tnm, ind)
    return "#{tnm} "+"*" *ind
  end

  def c_dump
    return PrimType.c_dump(@type_name, @ind_level)
  end

  # TODO:: should accept inputs like "int *"
  def PrimType.get_prim_type(tname, ind=0)
    key = c_dump(tname, ind)
    if @@prim_pool[key]==nil
      @@prim_pool[key] = PrimType.new(tname, ind)
    end
    return @@prim_pool[key]
  end
    
  def decl_c_dump(var_nm)
    return "#{c_dump}#{var_nm}"
  end
end

# FuncType has an indirection level, return type and list of
#   parameters.  To construct a FuncType, supply the return type in the
#   constructor and add the indirection level and parameters by calling
#   set_indirection (defined in Type) and add_param.
class FuncType < Type
  # TODO:: need to protect param_list from outside changes
  attr_reader :ret_type, :param_list

  # in C, function type is not named
  # Todo:: this can be a function pointer, so we may enable ind later.
  def initialize(ret)
    super(0)
    @ret_type = ret
    @param_list = Array.new
  end

  def add_param(param)
    raise "Parameter (#{param.decl_c_dump(0)}) already exists\n" if @param_list.index(param)!=nil
    @param_list.push(param)
  end

  def param_list_copy
    return @param_list.clone
  end

  def num_params
    return @param_list.size
  end

  def decl_c_dump(var_nm)
    ret = @ret_type
    raise "Return type #{ret.class.to_s} unsupported\n" if !ret.is_a?(PrimType)
    dump = "#{ret.c_dump}#{var_nm} ("
    @param_list.each_with_index do |p, i|
      dump += p.c_dump
      dump += ", " if i < @param_list.size-1
    end
    dump += ")"
    return dump
  end

  def FuncType.main_type
    int = Decl::PrimType.get_prim_type("int")
    main = Decl::FuncType.new(int)
    argc = Decl::Var.new("argc", int)
    main.add_param(argc)
    charpp = Decl::PrimType.get_prim_type("char", 2)
    argv = Decl::Var.new("argv", charpp)
    main.add_param(argv)
    return main
  end
end

# An array type includes the element type and the dimensions.  Call
# set_indirection (defined in Type) to set the indirection level.
class ArrayType < Type
  # TODO:: need to seal off dim from outside modification
  attr_reader :elem_type, :dim

  # dims is an array of positive integers
  def initialize(elem_type, dim)
    super(0)
    @elem_type = elem_type
    @dim = dim
  end

  def num_dim
    return @dim.size
  end

  # return a copy
  def dim_copy
    return @dim.clone
  end

  def decl_c_dump(var_nm)
    raise "Return type #{@elem_type.class.to_s} unsupported\n" if !@elem_type.is_a?(PrimType)
    dump = "#{@elem_type.c_dump}#{var_nm}"
    @dim.each { |d| dump += "[#{d.to_s}]" }
    return dump
  end
end

# VarDecl has variable name and its Type 
#
# TODO:: need to add symbol type---global, local, parameter---and
# storage type---extern or register.
class Var
  attr_reader :var_name, :var_type

  def initialize(name, type)
    @var_name = name
    @var_type = type
  end

  def c_dump
    return "#{@var_type.decl_c_dump(@var_name)}"
  end
end

end # module Decl

# Testing decl classes
module DeclTests
  def run
    # construct and dump a primitive type and a variable
    intp = Decl::PrimType.get_prim_type("int", 1)
    intp2 = Decl::PrimType.get_prim_type("int", 1)
    raise "Primitive type not uniquely represented\n" if intp!=intp2
    print "PrimType: #{intp.c_dump}\n"
    
    ap = Decl::Var.new("ap", intp)
    print "Decl::Var: #{ap.c_dump}\n"

    # function type
    mainfunc = Decl::Var.new("main", Decl::FuncType.main_type)
    print "Function: #{mainfunc.c_dump}\n"

    # array type
    int = Decl::PrimType.get_prim_type("int")
    arr = Decl::Var.new("A", Decl::ArrayType.new(int, [20,20]))
    print "Array: #{arr.c_dump}\n"
  end
  module_function :run
end
