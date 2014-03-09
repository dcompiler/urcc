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
end

