#!/usr/bin/ruby

$LOAD_PATH.unshift("..")

# Constructing the program in odd.c

require "ast/decl.rb"
require "ast/ast_scope.rb"
require "ast/ast_stat.rb"
require "ast/ast_expr.rb"

module AstTest
  def run
    # int main(int argc, char**argv)
    prog = Ast::Scope.new("prog")
    main = Ast::Func.new("main")
    main.add_func_type(Decl::FuncType.main_type)
    prog.add_child(main)
    
    # int i, parity;
    # char *answer;
    int_type = Decl::PrimType.get_prim_type("int")
    var_i = Decl::Var.new("i", int_type)
    var_par = Decl::Var.new("parity", int_type)
    char_s = Decl::PrimType.get_prim_type("char", 1)
    var_ans = Decl::Var.new("answer", char_s)
    main.add_sym(var_i)
    main.add_sym(var_par)
    main.add_sym(var_ans)
    
    # scanf("%d\n", &i);
    c1 = Ast::StrConst.new("%d")
    c2 = Ast::OpExpr.new("&", Ast::VarAcc.new(var_i))
    call = Ast::Call.new("scanf")
    call.add_param(c1)
    call.add_param(c2)
    scan_s = Ast::AssignStat.new(call)
    main.add_child(scan_s)

    # parity = i % 2;
    # if (parity == 0) goto L1;
    # answer = "odd";
    rhs = Ast::OpExpr.new("%", Ast::VarAcc.new(var_i), Ast::NumConst.new(2))
    main.add_child(Ast::AssignStat.new(rhs, Ast::VarAcc.new(var_par)))
    
    cond = Ast::OpExpr.new("==", Ast::VarAcc.new(var_par), Ast::NumConst.new(0))
    goto_s = Ast::GotoStat.new("L1", cond)
    main.add_child(goto_s)

    stat = Ast::AssignStat.new(Ast::StrConst.new("odd"), Ast::VarAcc.new(var_ans))
    main.add_child(stat)

    # goto L2;
    # L1:;
    # answer = "even";
    # L2:
    main.add_child(Ast::GotoStat.new("L2"))
    main.add_child(Ast::LabelStat.new("L1"))
    
    stat = Ast::AssignStat.new(Ast::StrConst.new("even"), Ast::VarAcc.new(var_ans))
    main.add_child(stat)
    
    main.add_child(Ast::LabelStat.new("L2"))

    # printf("%d is %s\n", i, answer);
    print = Ast::Call.new("printf")
    print.add_param(Ast::StrConst.new("%d is %s\\n"))
    print.add_param(Ast::VarAcc.new(var_i))
    print.add_param(Ast::VarAcc.new(var_ans))
    main.add_child(Ast::AssignStat.new(print))
    # main.add_child(print)

    # return 0;
    main.add_child(Ast::ReturnStat.new(Ast::NumConst.new(0)))

    print prog.c_dump

    File.new("odd_urcc.c", "w") << prog.c_dump
  end
  module_function :run
end

