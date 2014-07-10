require_relative "./llvm/llvm_grammar.rb"

class URCCFE
  attr_accessor :astroot
  def initialize(file)
    Log.reset
    @fileHandle = File.new(file, "r")
    @parser = ModuleParser.new()
    @astroot = @parser.parse(Token::Input.new(@fileHandle))
    @fileHandle.close
  end

  def URCCFE.dump_prog(astroot)
    result = "#include <stdio.h>\n" 
    result += "#include <stdlib.h>\n" 
    result += "\n/* func decls begin */\n" 
    astroot.each { |func|
      next if not func.is_a?Ast::Func or func.id == "main"
      result += func.type.decl_c_dump(func.id) + ";\n"
    }
    result += "/* func decls end */\n\n"
    result += astroot.c_dump
    return result
  end
end

