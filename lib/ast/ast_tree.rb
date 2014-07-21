#!/usr/bin/ruby

# This file includes the node classes of the abstract syntax tree.
# Comments are added using RDOC format, an explanation of which 
# can be found at http://rdoc.sourceforge.net/doc/index.html.
# Author:: Chen Ding

# Base class, with the following generic capabilities.  Direct
# modifications to the tree structure is allowed only for methods
# defined in this file.
#
# * an array of children nodes and a pointer to the parent
# * methods for inserting and deleting nodes

#require_relative "./ast_scope.rb"
#require "ast/ast_stat.rb"
#require "ast/ast_expr.rb"

module Ast

class Node
  attr_reader :id, :parent
  attr_accessor :tags
  # uncomment this for debugging
  attr_reader :children

  def initialize(id=nil)
    if id==nil
      @id = self.class.to_s
    else
      @id = id
    end
    @children = Array.new
    @tags = Hash.new
  end

  def child(i)
    chd = children[i]
    raise "Child #{i} does not exist\n" if chd==nil
    return chd
  end

  # traverse itself and every child in the sub-tree
  def each(order="preorder", &visitor)
    raise "Unknown order\n" unless order=="preorder" or order=="postorder"
    visitor.call(self) if order == "preorder"
    @children.each do |child| 
      child.each(order, &visitor)
    end
    visitor.call(self) if order == "postorder"
    return nil
  end

  # Find implemented using each.  A better implementation is to return
  # at the first match.  Now it returns the last match.
  def find(&checker)
    answer = nil
    each do |n|
      if checker.call(n)
        answer = n
      end
    end
    return answer
  end

  # search the sub-tree (and itself)
  def not_working_find(&checker)
    return self if checker.call(self) # search me successful
    @children.find do |child| 
      result = child.find(&checker)
      if result!=false
        return result
      else
        return false
      end
    end
    return false                      # nothing found
  end

  # search parents
  def find_parent(&checker)
    return self if checker.call(self)
    return nil if parent==nil
    return self.parent.find_parent(&checker)
  end

  # traverse in pre-order but with level info
  def each_with_level(level=0, &visitor)
    raise "Be positive (or at least equivocal)\n" if level<0
    visitor.call(level, self)
    @children.each do |child| child.each_with_level(level+1, &visitor) end
    return nil
  end

  # Print tree.  
  # Todo:: let it generate in html format.
  def print_tree(level=0)
    each_with_level do |lev, n| print "  " *lev + "#{n.id}\n" end
  end

  def print_tree_no_iterator(level=0)
    1.step(level) do |i|
      print("#{i}-")
    end
    print("#{ id }\n")
    @children.each do |child| child.print_tree_no_iterator(level+1) end
    return nil
  end

  # an outsider can only examine but not change children
  def children_copy
    return children.clone
  end

  # add node nc as the last child
  def add_child(nc)
    nc.insert_me("childof", self)
  end

  # Insert myself around node n.  The pos can be before, after,
  # childof.  ALL TREE MODIFICATIONS ARE DONE THROUGH THIS PROCEDURE.
  def insert_me(pos, n)
    raise "Insertion of non AstNode object\n" if !n.is_a?(Node)
    raise "Insertion of an attached node.\n" if @parent!=nil
    case pos
      when "childof"
        n.children.push(self)
        @parent = n

      when "before", "after"
        list = n.parent.children
        # find the child
        i = list.index(n)
        # insert 
        list.insert(i+1, self) if pos=="after"
        list.insert(i, self) if pos=="before"
        @parent = n.parent
      else
        raise "Unsupported insertion type.  Only ones allowed are before, after, and childof"
    end # case
    return nil
  end
  
  # Self removal
  def detach_me
    @parent.children.delete(self)
    @parent = nil
  end

  # Detach myself and move to the pos near node
  def move_me(pos, node)
    detach_me
    insert_me(pos, node)
  end

  # find symbol definition and return the first match
  def sym_def(name)
    if self.is_a?(Scope) and Scope.find_sym(name)!=nil
        return Scope.sym_def(name)
    elsif self.parent != nil
      return self.parent.sym_def(name)
    else
      return nil  # not found
    end
  end

  # Add used variables in code to the symbol table. If conflict with
  # an existing definition, try second time by removing all symbols first.
  # Return true is successful; otherwise false.
  def sym_consistent?
    RUtils::expect(self, Node, "code")
    # prepare 2nd try
    try_again = callcc{|cont| cont}
    # find a conflicting definition
    self.find do |node|
      if node.is_a?(VarAcc)
        established_def = sym_def(node.var.var_name)
        if established_def==nil
          self.add_sym(node.var)
print node.var.c_dump
        elsif established_def != node # a conflict, retry
          if try_again!=nil
            scope = node.find_parent do |p| p.is_a?(Scope) end
            return false if scope==nil
            scope.remove_sym
            try_again.call
          end
          return false
        end # branch for retry
        # same definition, no conflict
      end # VarAcc
      # other nodes need no check
    end # find
    return true # all checked, no conflict
  end

  def inspect
    result = "node #{self.class.to_s} #{self.id}, "
    result << "parent #{parent.class.to_s} #{parent.id}, " unless parent.nil?
    result << "#{children.size} child(ren), "
    children.each_with_index do |p, i| 
      result << "#{p.class.to_s} #{p.id}"
      result << ", " if i<children.size-1 
    end
    result
  end
  
  protected
  def children
    return @children
  end

  def add_sym(var)
    scope = self
    while scope!=nil and !scope.is_a?(Scope)
      scope = scope.parent
    end
    raise "No surrounding scope to add symbol (#{var.c_dump})\n" if scope==nil
    # call add_sym defined for Scope class objects
    scope.add_sym(var)
  end
end

end # module Ast

class AstNodeTests
  def AstNodeTests.basic
    n = Array.new
    0.step(4) do |i| n[i] = Ast::Node.new("node #{i.to_s}") end
    n[1].insert_me("childof", n[0])
    n[2].insert_me("before", n[1])
    n[3].insert_me("childof", n[1])
    n[4].insert_me("after", n[3])
    n[0].print_tree
  end
  def AstNodeTests.more
    require "ast/ast_stat.rb"
    require "ast/ast_expr.rb"
    int = Decl::PrimType.get_prim_type("int")
    i = Decl::Var.new("i", int)
    acc_i = Ast::VarAcc.new(i)
    s1 = Ast::AssignStat.new(Ast::NumConst.new(0), acc_i)
    intf = Decl::FuncType.new(int)
    foo = Ast::Func.new("foo")
    foo.add_func_type(intf)
    foo.add_child(s1)
    print foo.c_dump
  end
end

