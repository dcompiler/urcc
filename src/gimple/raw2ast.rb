#!/usr/bin/ruby

require "ast/decl.rb"
require "ast/ast_scope.rb"
require "ast/ast_stat.rb"
require "ast/ast_expr.rb"
require "gimple/gimp2raw.rb"

class URCCFE
  attr_accessor :astroot
  def initialize(file)
    ir1 = Gimple2Raw.new(file) 
    ir2 = Raw2Ast.new(ir1.funcList)
    @astroot = ir2.prog
  end
end

class Raw2Ast
  attr_accessor :prog, :globalVarTable
  def initialize(funcList)
    # We only support a single file compilation for now, so we 
    # just need one scope.
    @prog = Ast::Scope.new("prog")
    
    # Table for global symbols
    @globalVarTable = Hash.new
    funcList.each { |f| FuncBuilder.new(f, self).Construct() }
  end
end

# FuncBuilder builds Ast::Func based on the Raw gimple information
class FuncBuilder < RawFunc
  def initialize(rawFunc, global)
    # copy from rawFunc
    @name = rawFunc.name
    @paramList = rawFunc.paramList
    @rawEntries = rawFunc.rawEntries
    
    # a pointer to class Raw2Ast which instantiated this class
    @global = global
    
    # the ast node for this function    
    @astFunc = Ast::Func.new(@name)

    # hash table for variables, each 
    @varTable   = Hash.new
    @labelTable = Hash.new
    
    # helper function to transform operators
    Operator.Init
    # helper function to generate a unique label
    LabelGenerator.Init
    # helper function to generate a unique variable name
    NameGenerator.Init    
  end

  def Construct
    @astFunc.add_func_type(Gen_Function_Decl())
    Add_Statements()
    @global.prog.add_child(@astFunc)
  end 
  
  # Add function return type and parameters
  def Gen_Function_Decl
    # work around for main function, which may use pointer
    # as parameter, e.g. char** argv
    #return Decl::FuncType.main_type if @name == "main" 
    
    # add the return type
    funcType = Decl::FuncType.new(Gen_Return_type())
    
    #add parameters
    pid = Get_Attribute(Get_Attribute("@1", "type"), "prms")
    @paramList.each do |pname|
      arg = Decl::Var.new(pname, Gen_Parameter_Type(pid))  
      @varTable[pname] = arg
      funcType.add_param(arg)
      pid = Get_Attribute(pid, "chan") # Get the next item
    end
    return funcType
  end
  
  # Generate the function return value type
  def Gen_Return_type
    rid = Get_Attribute(Get_Attribute("@1", "type"), "retn")
    return Decl::PrimType.get_prim_type(Get_Name(rid))
  end
  
  # Generate the type for each virtual parameter 
  def Gen_Parameter_Type(pid)
    vid = Get_Attribute(pid, "valu")
    if Get_RawType(vid) == "pointer_type" then
      return Decl::PrimType.get_prim_type(Get_Pointer_Type(vid))
    else
      return Decl::PrimType.get_prim_type(Get_Name(vid))      
    end
  end
  
  # Add all statements in, and add all variable declarations meanwhile
  def Add_Statements
    sid = Get_Attribute(Get_Attribute("@1", "body"), "body")    
    Check_Type(sid, "statement_list")
    Add_Stmt_Block(sid, @astFunc)
  end
   
  # A recursive function to add statement blocks
  def Add_Stmt_Block(sid, astBlock)
    node = Get_RawEntry(sid)
    stmtList = Array.new
    node.attributes.each { |k,v| stmtList[k.to_i] = v }
    
    # Add each statement one by one
    stmtList.each do |s|
      next if not s #skip empty one
      case Get_RawType(s)
        when "modify_expr":
          Add_Modify_Stmt(s, astBlock)
        
        when "call_expr":
          Add_Call_Stmt(s, astBlock)
        
        when "cond_expr":
          Add_Cond_Stmt(s, astBlock) # might call Add_Stmt_Block inside
       
        when "goto_expr":
          Add_Goto_Stmt(s, astBlock)
      
        when "label_expr":
          Add_Label_Stmt(s, astBlock)
          
        when "return_expr":
          Add_Return_Stmt(s, astBlock)

        # To process bind_expr, just process its body, which should
        # be a normal statement_list
        when "bind_expr":
          Add_Stmt_Block(Get_Attribute(s, "body"), astBlock)
      
        else     raise "Unexpected gimple node type.\n"
      end
    end
  end
  
  # type is a string like int[5][10]
  def Gen_Array_Type(type)
    element_type = Decl::PrimType.get_prim_type(type[0..type.index("[")-1])
    dimstr = type[/\[.*\]/] # will be "[5][10]"
    dimsplt = dimstr.split("[") # will be ["","5]","10]" ]
    dim = Array.new
    dimsplt.reverse_each { |d| dim.push(d.delete("]").to_i) if not d.empty? }
    return Decl::ArrayType.new(element_type, dim)
  end
  
  # "scpe" equals to "@1" means the varible in current function's scope
  def Is_Global_Var(id)
    if Get_Attribute(id, "scpe") == "@1" then
      return false
    else
      return true
    end
  end
  
  # unit function for adding a variable
  # Create a Decl::Var if it has not been created, return a Ast::VarAcc
  def Gen_Var_Decl(id)
    Check_Type(id, "var_decl")
    
    if Is_Global_Var(id) then
      # Get_Name(id) should be sufficient here because there is no temporary
      # global variable
      astVar = @global.globalVarTable[Get_Name(id)]
      return Ast::VarAcc.new(astVar) if astVar
    else
      return Ast::VarAcc.new(@varTable[id]) if @varTable[id]
    end
        
    # TODO: Scope can distiguish whether the varaible is local or global 
    # Get_Attribute(id, "scpe")
    var_type = Get_Type(id)
    if var_type[-1].chr == "*" then # pointer type, e.g. char*
      astType = Decl::PrimType.get_prim_type(var_type.delete("*"), 
                                             var_type.count("*"))
    elsif var_type[/\[\d*\]/] then # array type, e.g. int[5][10]
      astType = Gen_Array_Type(var_type)
    else
      astType = Decl::PrimType.get_prim_type(var_type)
    end
    
    var_name = Get_Name(id)    
    if not var_name then
      # this is an anonymous temporary variable introduced by gcc 
      # gimple generator
      var_name = NameGenerator.Gen_Name
    else
      # C does not allow a "." exist in a variable name
      var_name.gsub!(".", "_")
    end 

    astVar = Decl::Var.new(var_name, astType)    
    if Is_Global_Var(id) then
      # add to the global scope
      @global.globalVarTable[Get_Name(id)] = astVar
      @global.prog.add_sym(astVar)
      if Get_Attribute(id, "init") then
        # has initial value
        lhs = Ast::VarAcc.new(astVar)
        rhs = Gen_Expression(Get_Attribute(id, "init"))
        @global.prog.add_child(Ast::AssignStat.new(rhs, lhs))
      end
    else
      @varTable[id] = astVar
      @astFunc.add_sym(astVar)
    end
    
    return Ast::VarAcc.new(astVar)
  end
  
  # unit function for adding a constant
  def Gen_Const_Decl(id)
    case Get_RawType(id)
      when "integer_cst":
        #TODO: need to combine low and high
        val = Ast::NumConst.new(Get_Attribute(id, "low").to_i)
      when "string_cst":
        val = Ast::StrConst.new(Get_Attribute(id, "strg"))
      when "real_cst":
        # This information is missing if we use old version gcc (4.2.2 is fine)
        val = Ast::NumConst.new(Get_Attribute(id, "valu").to_f)
      else
        raise "A integer_cst, real_cst or string_cst node is expected.\n" 
    end
    return val
  end
  
  def Get_Int_Const_Value(id)
    Check_Type(id, "integer_cst")
    low  = Get_Attribute(id, "low")
    high = Get_Attribute(id, "high")
    if not high or high == "0"
      # positive number
      return low.to_i
    elsif high == "-1"
      # negative number
      return (-1) *(- low.to_i );
    else 
      #TODO: a double word long integer
    end
  end
    
  # unit function for adding a virtual parameter reference
  def Gen_Parm_Decl(id)
    Check_Type(id, "parm_decl")
    # Decl::Var should have been generated in Gen_Function_Decl
    return Ast::VarAcc.new(@varTable[Get_Name(id)])
  end
  
  # unit function for adding an array reference  
  def Gen_Array_Ref(id)
    Check_Type(id, "array_ref")
    arrayid = Get_Attribute(id, "op0")
    indexid = Get_Attribute(id, "op1")
    if Get_RawType(arrayid) == "string_cst" then
      return Gen_Const_Decl(arrayid)
    elsif Get_RawType(arrayid) == "array_ref" then
      # This means the array is multi-dimension
      astArray = Gen_Array_Ref(arrayid)
      astArray.add_dim( Gen_Expression(indexid) )
      return astArray
    else
      astArray = Gen_Var_Decl(arrayid)
      astArray.add_dim( Gen_Expression(indexid) )
      return astArray
    end    
  end  
  
  def Gen_Call_Expr(id)
    Check_Type(id, "call_expr")  
    nameid = Get_Attribute(Get_Attribute(id, "fn"), "op0")
    call = Ast::Call.new(Get_Name(nameid))
    aid = Get_Attribute(id, "args")
    while aid do
      param = Gen_Expression(Get_Attribute(aid, "valu"))
      call.add_param(param)
      aid = Get_Attribute(aid, "chan")
    end
    return call
  end
    
  def Gen_Addr_Expr(id)
    Check_Type(id, "addr_expr")  
    opid = Get_Attribute(id, "op0")
    
    if Get_RawType(opid) == "var_decl" then
      # This is an address reference
      return Ast::OpExpr.new("&", Gen_Var_Decl(opid))        
    elsif Get_RawType(opid) == "array_ref" then
      # This is an array reference
      return Gen_Array_Ref(opid)
    else
      raise "Unrecognized addr_expr"
    end
  end
  
  # In gimple format, a variable operand could be a variable, a virtual 
  # parameter, or an array reference.
  def Gen_Variable(id)
    case Get_RawType(id)
      when "var_decl":
        # generate a variable access
        return Gen_Var_Decl(id)
      when "parm_decl":
        return Gen_Parm_Decl(id)
      when "array_ref":
        return Gen_Array_Ref(id)
      else
        raise "A variable is expected.\n"
    end
  end
  
  # unit function for adding an expression, which can be a variable, a constant,
  # a function call, or an expression with at most 2 operands. 
  def Gen_Expression(id)
    type = Get_RawType(id)
    case type
      when "var_decl","parm_decl","array_ref":
        return Gen_Variable(id)
      when "integer_cst", "real_cst", "string_cst":
        return Gen_Const_Decl(id)         
      when "call_expr":
        return Gen_Call_Expr(id)
      when "addr_expr":
        return Gen_Addr_Expr(id)
      else
        if Operator.Is_Unary(type) then
          id0 = Get_Attribute(id, "op0")
          return Ast::OpExpr.new(Operator.Is_Unary(type), Gen_Expression(id0))
        elsif Operator.Is_Binary(type) then
          id0 = Get_Attribute(id, "op0")
          id1 = Get_Attribute(id, "op1")
          return Ast::OpExpr.new(Operator.Is_Binary(type),
                                 Gen_Expression(id0), Gen_Expression(id1))
        else
          raise "Unsupported operator #{type}.\n"
        end
    end    
  end
  
  def Add_Modify_Stmt(sid, astBlock)
    # after gimple, only variable can be lhs 
    lhs = Gen_Variable(Get_Attribute(sid, "op0"))
    rhs = Gen_Expression(Get_Attribute(sid, "op1"))
    astBlock.add_child(Ast::AssignStat.new(rhs, lhs))
  end
 
  def Add_Call_Stmt(sid, astBlock)
    astBlock.add_child(Ast::AssignStat.new(Gen_Call_Expr(sid)))
  end
  
  def Get_Label_Name(id)
    Check_Type(id, "label_decl")
    name = Get_Name(id)
    # if label name is artificial, we need generate a name for it
    # search the hash table first
    name = @labelTable[id] if not name 
    # still can not find it, create a new name
    if not name then 
      name = LabelGenerator.Gen_Label
      @labelTable[id] = name
    end
    return name
  end
  
  def Add_Goto_Stmt(sid, astBlock)
    label = Get_Label_Name(Get_Attribute(sid, "labl"))
    astBlock.add_child( Ast::GotoStat.new(label) )
  end  
  
  def Add_Label_Stmt(sid, astBlock)
    label = Get_Label_Name(Get_Attribute(sid, "name"))
    astBlock.add_child( Ast::LabelStat.new(label) )  
  end
  
  def Add_Return_Stmt(sid, astBlock)
    eid = Get_Attribute(sid, "expr")
    if not eid or Get_RawType(eid) == "result_decl" then
      # "return" stands alone
      astBlock.add_child(Ast::ReturnStat.new)
    elsif Get_RawType(eid) == "modify_expr" then
      opnd = Get_Attribute(eid, "op1")
      astBlock.add_child( Ast::ReturnStat.new( Gen_Expression(opnd) ) )
    end
  end  
  
  # A complicated case, we need to create new goto and label statements
  # if they are not already there.
  #
  # we turn if-then-else
  #   if (cond) {
  #     if-branch
  #   } else {
  #     else-branch
  #   }
  # into 
  #   if (cond) goto L1;
  #   goto L2;
  #   L1:;
  #     if-branch
  #     goto L3;
  #   L2:;
  #     else-branch;
  #   L3:;
  #     ...
  # When the else branch is empty, we just use "goto L3" after "if (cond) goto L1;"  
  def Add_Cond_Stmt(sid, astBlock)  
    cond = Gen_Expression(Get_Attribute(sid, "op0"))    
    op1 = Get_Attribute(sid, "op1")    
    op2 = Get_Attribute(sid, "op2")
    Check_Type(op1, "statement_list")
    Check_Type(op2, "statement_list")
    
    op1_first_stmt = Get_Attribute(op1, "0")
    if Get_RawType(op1_first_stmt) == "goto_expr" then
      # If the first stmt in if-branch is a goto stmt, then we do not
      # need to create new goto. Actually, we will move the goto stmt 
      # to attach with the cond stmt.
      label_one = Get_Label_Name(Get_Attribute(op1_first_stmt, "labl"))
      new_label_one = false 
    else
      # Otherwise, we need to create new goto and label.
      label_one = LabelGenerator.Gen_Label
      new_label_one = true
    end
    # always add goto stmt here to get to if-branch
    astBlock.add_child( Ast::GotoStat.new(label_one, cond) )
    
    op2_first_stmt = Get_Attribute(op2, "0")
    if not op2_first_stmt then    
      # else-branch is empty
      label_three = LabelGenerator.Gen_Label
      new_label_three = true
      label_two = label_three
      new_label_two = false # we do not want to insert L2
      
    elsif Get_RawType(op2_first_stmt) == "goto_expr" then
      # the first stmt in else-branch is a goto stmt
      label_two = Get_Label_Name(Get_Attribute(op2_first_stmt, "labl"))
      new_label_two = false
      if new_label_one then
        # we created "goto L1", we need another "goto L3" at the end of if-branch
        label_three = LabelGenerator.Gen_Label
        new_label_three = true
      else
        # No worry if "goto L1" is already there
        new_label_three = false
      end
      
    else
      # classic if-then-else
      label_two = LabelGenerator.Gen_Label 
      new_label_two = true
      label_three = LabelGenerator.Gen_Label
      new_label_three = true
    end    
    # always add goto stmt here to get to else-branch
    astBlock.add_child( Ast::GotoStat.new(label_two) ) 
    
    #process if-branch only if we have created a new label
    # TODO: My assumption is if the first stmt in if-branch is a goto stmt,
    #       then it has to be the only stmt in that statement_list, then no
    #       need to process if-branch
    if new_label_one then
      block_if = Ast::Block.new(label_one)
      astBlock.add_child( block_if )
          
      # insert label at the beginning of if-branch
      block_if.add_child( Ast::LabelStat.new(label_one) )
      
      #process if-branch
      Add_Stmt_Block(op1, block_if) 
      
      # insert goto at the end of if-branch if we have created L3 and
      # else-branch is not empty
      if new_label_three and new_label_two then
        block_if.add_child( Ast::GotoStat.new(label_three)  )
      end
    end
    
    # process else-branch
    if new_label_two then
      block_else = Ast::Block.new(label_two)
      astBlock.add_child( block_else )
    
      # insert label at the beginning of else-branch
      block_else.add_child( Ast::LabelStat.new(label_two) )
      #process else-branch
      Add_Stmt_Block(op2, block_else)   
    end
    
    # insert label at the beginning of the block after if-branch and else-branch
    if new_label_three then
      astBlock.add_child( Ast::LabelStat.new(label_three) )
    end
  end
  
  def Check_Type(id, expected)
    raise "A #{expected} node is expected.\n" if Get_RawEntry(id).rawType != expected
  end
end


module Operator
  def Operator.Init
    @uTable = { "negate_expr"    => "-",         "truth_not_expr" => "!",  
                "float_expr"     => "(double)",  "fix_trunc_expr" => "(int)"}
    @bTable = { "plus_expr"    => "+",  "minus_expr"     => "-",  "mult_expr"      => "*", 
              "trunc_div_expr" => "/",  "rdiv_expr"      => "/",  "trunc_mod_expr" => "%",
              "truth_and_expr" => "&&", "truth_or_expr"  => "||", "eq_expr"        => "==",      
              "ne_expr"        => "!=", "lt_expr"        => "<",  "le_expr"        => "<=",
              "gt_expr"        => ">",  "ge_expr"        => ">=", "lshift_expr"    => "<<",
              "rshift_expr"    => ">>" }
  end
                 
  # If opr is a unary operator, return the its string form; Otherwise, return nil.
  def Operator.Is_Unary(opr)
    return @uTable[opr]
  end
  
  # If opr is a binary operator, return the its string form; Otherwise, return nil.
  def Operator.Is_Binary(opr)
   return @bTable[opr]
  end  
end

module LabelGenerator
  def LabelGenerator.Init
    @counter = 0
  end

  def LabelGenerator.Gen_Label
    @counter += 1
    return "URCC_Label_#{@counter}"
  end
end 

module NameGenerator
  def NameGenerator.Init
    @counter = 0
  end

  def NameGenerator.Gen_Name
    @counter += 1
    return "URCC_Temp_Var_#{@counter}"
  end
end 
