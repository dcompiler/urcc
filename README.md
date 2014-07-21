
URCC Compiler
====

# RELEASE

version: 0.0.0

# REQUIREMENTS
* Ruby 1.9 +
* Ruby gem 1.8 +
* parseconfig
* LLVM 3.3 +
* Clang 3.3 +


# INTRO

URCC is a simple compiler tool built for LLVM, in Ruby. It parses IR representation that LLVM emits, and add user-defined passes for optimization.

Instead of writing LLVM passes, users could implement and test optimization passes in ruby, which is ideal for algorithm verifications, studying, and teaching.


# INSTALL



```
git clone https://github.com/dcompiler/urcc.git
cd urcc
gem build urcc.gemspec
[sudo] gem install urcc-*.gem
```

Test if your installation works.

```
urcc --version
```


# QUICK START

## Initialization

For first time run, URCC will add config folder to ```$HOME/.urcc```, and add a config file and a PASSES folder where pass files are defined.

## Compiling C code

Run ```urcc *.c``` to compile C source file. The default outputs includes:

* Un-optimized version of IR;
* Un-optimized version of IR C dump;
* Un-optimized version of compiled binary;
* Optimized version of IR;
* Optimized version of IR C dump;
* Optimized version of compiled binary;

The output could be defined in config file.

## Adding your own passes

By default, passes are contained in ```$HOME/.urcc/PASSES```, and are defined individually as ruby files. Edit the config file if you want to include your pass file names in PASS > passes, separated by commas.

A pass should be defined as a ruby Proc named 'Pass', inside a module named 'PassModule'. The 'Pass' Proc takes the AST tree of the program as input.

Following is an example pass which does nothing.

```ruby
# Define a HelloWorld pass                                                                                                              
module PassModule

  Pass = Proc.new do |prog|

    p prog

  end

end
```

To include this pass, save it as "HelloWorld.rb" under PASSES directory, and add HelloWorld to config file PASSES > passes.