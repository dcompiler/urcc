
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

URCC is a source-to-source C compiler written in Ruby. It can use GCC and LLVM as front-ends.  The current distribution assumes the use of LLVM, which it uses to parse C source code into LLVM IR.  Then it creates the URCC intermediate representation and supports user-defined passes for optimization.  It generates C code after optimization.

Instead of writing compiler passes in C/C++, users could implement and test optimization passes in Ruby, which is easier to program and experiment and helps compiler prototyping and teaching.


# INSTALL

Installation requires Ruby Rake and ParseConfig installed. If you don't have them, run following to install.

```
[sudo] gem install rake
[sudo] gem install parseconfig
```

And then run rake to install:

```
git clone https://github.com/dcompiler/urcc.git
rake install
```

Test if your installation works.

```
urcc --version
```

If URCC executable doesn't work, try adding your Gem bin path to your PATH. Use the following command to find about your Gem bin path:

```
ruby -e "puts Gem.bindir"
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

## IR documentation

The intermedite representation (IR) is abstract syntax tree (AST).  An easy way to browse AST classes and functions is to use rdoc to generate code documentation:

```
cd [repos]/lib/ast
rdoc *.rb
```

Open doc/table_of_contents.html in a Web browser.

