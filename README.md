URCC Compiler
====

* RELEASE

version: 0.0.0


* INTRO

URCC is a simple compiler tool built for llvm, in ruby.
It parses IR representation llvm emits, and add user-defined
passes for optimization.

Instead of writing llvm passes, users could implement and test optimization
passes in ruby, which is ideal for algorithm verifications and teaching.

