# This file specifies the gem info for urcc

Gem::Specification.new do |s| 

  s.name        = "urcc"
  s.version     = "0.0.0"
  s.date        = "2014-07-11"
  s.summary     = "Hola"
  s.description = "A ruby frontend for llvm."
  s.authors     = "C. Ding"
  s.bindir      = "bin"
  s.executables = ["urcc"]  
  s.files       = %w[README.md
                  bin/cfg
                  bin/helloworld.rb
                  bin/ssa
                  bin/test.rb
                  bin/urcc
                  bin/urcc.config
                  bin/urcc_gcc
                  doc/parser.txt
                  lib/ast/ast_expr.rb
                  lib/ast/ast_scope.rb
                  lib/ast/ast_stat.rb
                  lib/ast/ast_tree.rb
                  lib/ast/decl.rb
                  lib/cfg/cfg.rb
                  lib/gimple/gimp2raw.rb
                  lib/gimple/raw2ast.rb
                  lib/ir/llvm/llvm_grammar.rb
                  lib/ir/parser/grammar_rule.rb
                  lib/ir/parser/rule_tests.rb
                  lib/ir/parser/token.rb
                  lib/ir/urccfe.rb
                  lib/misc/log.rb
                  lib/misc/log_test.rb
                  lib/misc/utils.rb
                  lib/ssa/ssa.rb
                  lib/tssa/Makefile
                  lib/tssa/OptPass.rb
                  lib/tssa/README.txt
                  lib/tssa/TSSAPass.rb
                  lib/tssa/tests/sort.c
                  lib/tssa/tests/test.c
                  lib/tssa/tssa.cpp
                  lib/tssa/tssa.h
                  lib/tssa/tssa_test.cpp
                  lib/tssa/urcc
                  ]
  
end
