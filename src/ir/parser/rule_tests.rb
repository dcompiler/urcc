require 'stringio'
require './grammar_rule'

module ExampleLit
  def initialize
    @a = Literal[ "A" ]
    @input = Token::Input.new( StringIO.new( "A B" ) )
  end
end

describe "Literal#lookahead" do
  include ExampleLit
  it "return non-nil at a match" do
    @a.lookahead( @input.line[0] ).should_not eq( nil )
    @a.lookahead( @input.line.reverse[0] ).should eq( nil )
  end
end

describe "Literal#parse" do
  include ExampleLit
  it "matches and consumes the input" do
    @a.parse( @input ).should eq( @a )
    @input.line.should eq( [ "B" ] )
  end
end

describe "Text#lookahead" do
  it "should not match }" do
    Text.lookahead( "}" ).should eq( nil )
  end
end

describe "InputParse#next_line" do
  it "parses for commas" do
    input = Token::Input.new( StringIO.new("a, b ; this is a comment") )
    input.line.should eq( [ "a", ",", "b" ] )
  end
end

module ExampleRules
  def initialize
    @alt = AltRule.new(:line, [ Literal["yes"], Literal["NO"] ] )
    @seq = SeqRule.new(:line, [ @alt, Literal[","], Literal["Madam"] ] )
    @rep = RepRule.new(:line, @alt, [","] )
    @line = "Yes, Madam"
  end
end

describe "SeqRule#parse" do
  include ExampleRules
  it "parses a polite reply" do
    @seq.lookahead( "yes" ).should_not eq( nil )
    @seq.lookahead( "madam" ).should eq( nil )
    input = Token::Input.new( StringIO.new( @line ) )
    @seq.parse( input ).should eq( [ ] )
    input.line.should eq( [ ] )
  end
end

describe "AltRule#parse" do
  include ExampleRules
  it "parses literals" do
    @alt.lookahead( "yes" ).should_not eq( nil )
    @alt.lookahead( "bluh" ).should eq( nil )
    input = Token::Input.new( StringIO.new( @line ) )
    result = input.line.clone
    result.shift
    @alt.parse( input ).should eq( Literal["yes"] )
    input.line.should eq( result )
  end

  it "parses nested AltRules" do
    @nested_alt = AltRule.new(:line, [ Literal["Maybe"], @alt ] )
    input = Token::Input.new( StringIO.new( @line ) )
    @nested_alt.parse( input ).should eq( Literal["yes"] )
  end
end

describe "RepRule#parse" do
  include ExampleRules
  it "parses an ambiguous reply" do
    input = Token::Input.new( StringIO.new( "yes no yes no no, Madam" ) )
    @rep.parse( input ).should eq( [] )
    input.line.should eq( [",", "Madam"] )
  end
end

module ExampleProg
  def initialize
    @var_decl_rule = SeqRule.new(:line, [ Text, Text ] )
    @stmt_rule = SeqRule.new(:line, [ Text, Literal["="], @var_decl_rule ] )
    @stmts_rule = RepRule.new( :file, @stmt_rule, "}" )
    @func_rule = SeqRule.new(:file, [ Literal["func_head"], @stmts_rule, Literal["}"] ] )
    @var_decl = "i32 %x"
    @line = "%add = #{@var_decl}"
    @stmts = "#{[@line, @line, @line] * "\n"}\n"
    @func = "func_head\n" + @stmts + "\n}\n"
  end
end

describe "Mixed-Rule#parse" do
  include ExampleProg
  it "finds a typed variable" do
    input = Token::Input.new( StringIO.new( @var_decl ) )
    @var_decl_rule.parse( input ).should eq( Token.tokenize( @var_decl ) )
  end

  it "finds a statement" do
    input = Token::Input.new( StringIO.new( @line ) )
    @stmt_rule.parse( input ).size.should eq( 2 )
  end

  it "finds a block of statements" do
    # finishes with }
    input = Token::Input.new( StringIO.new( @stmts + "\n}\n" ) )
    @stmts_rule.parse( input ).size.should eq( 3 )

    # finishes at the end of the file
    input = Token::Input.new( StringIO.new( @stmts ) )
    block = @stmts_rule.parse( input )
    block.size.should eq( 3 )
  end

  it "finds a function" do
    input = Token::Input.new( StringIO.new( @func ) )
    @func_rule.parse( input ).size.should eq( 1 )
  end
end

