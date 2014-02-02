require 'grammar_rule'

module ExampleLit
  def initialize
    @a = Literal[ "A" ]
    @line = [ "A", "B" ]
  end
end

describe "Literal#lookahead" do
  include ExampleLit
  it "return non-nil at a match" do
    @a.lookahead( @line[0] ).should_not eq( nil )
    @a.lookahead( @line.reverse[0] ).should eq( nil )
  end
end

describe "Literal#parse" do
  include ExampleLit
  it "matches and consumes the input" do
    include ExampleLit
    file = nil
    @a.parse( @line, file ).should eq( @a )
    @line.should eq( [ "B" ] )
  end
end

describe "InputParse#next_line" do
  class TestParse
    include InputParse
  end

  it "parses for commas" do
    require 'stringio'
    file = StringIO.new("a, b ; this is a comment")
    line = TestParse.new.next_line( file )
    line.should eq( [ "a", ",", "b" ] )
  end
end

module FuncDecl
  def initialize
    file = StringIO.new( "define i32 @square(i32 %x) nounwind {\n}" )
  end
end

module ExStmt
  def initialize
  end
end

module ExampleProg
  def initialize
    @var_decl_rule = SeqRule.new(:line, [ Text, Text ] )
    @var_decl = Token.tokenize( "i32 %x" )
    @stmt_rule = SeqRule.new(:line, [ Text, Literal["="], @var_decl_rule ] )
    @stmts_rule = RepRule.new( :file, @stmt_rule, "}" )
    @func_rule = SeqRule.new(:file, [ Literal["func_head"], @stmts_rule, Literal["}"] ] )
    stmt = "%add = i32 %mul"
    @line = Token.tokenize( stmt )
    @stmts = "#{[stmt, stmt, stmt] * "\n"}\n"
    @func = "func_head\n" + @stmts + "\n}\n"
  end
end

describe "Mixed-Rule#parse" do
  include ExampleProg
  include InputParse
  it "finds a typed variable" do
    @var_decl_rule.parse( @var_decl.clone, nil ).should eq( @var_decl )
  end

  it "finds a statement" do
    @stmt_rule.parse( @line.clone, nil ).size.should eq( 2 )
  end

  it "finds a block of statements" do
    # finishes with }
    file = StringIO.new( @stmts + "\n}\n" )
    @stmts_rule.parse( @line.clone, file ).size.should eq( 4 )

    # finishes at the end of the file
    file = StringIO.new( @stmts )
    @stmts_rule.parse( @line.clone, file ).size.should eq( 4 )
  end

  it "finds a function" do
    file = StringIO.new( @func )
    line = next_line( file )
    @func_rule.parse( line, file ).size.should eq( 1 )
  end
end

module ExampleRules
  def initialize
    @alt = AltRule.new(:line, [ Literal["yes"], Literal["NO"] ] )
    # @alt = AltRule.new(:line){ |a| a.choices = [ Literal["yes"], Literal["NO"] ] }
    @seq = SeqRule.new(:line, [ @alt, Literal[","], Literal["Madam"] ] )
    @rep = RepRule.new(:line, @alt, [","] )
    @line = Token.tokenize( "Yes, Madam" )
  end
end

describe "SeqRule#parse" do
  include ExampleRules
  it "parses a polite reply" do
    @seq.lookahead( "yes" ).should_not eq( nil )
    @seq.lookahead( "madam" ).should eq( nil )
    line, file = @line.clone, nil
    @seq.parse( line, nil ).should eq( [ ] )
    line.should eq( [ ] )
  end
end

describe "AltRule#parse" do
  include ExampleRules
  it "parses literals" do
    @alt.lookahead( "yes" ).should_not eq( nil )
    @alt.lookahead( "bluh" ).should eq( nil )
    line = @line.clone
    file = nil
    @alt.parse( line, file ).should eq( Literal["yes"] )
    line.should eq( @line[1..-1] )
  end

  it "parses nested AltRules" do
    @nested_alt = AltRule.new(:line, [ Literal["Maybe"], @alt ] )
    @nested_alt.parse( @line.clone, nil ).should eq( Literal["yes"] )
  end
end

describe "RepRule#parse" do
  include ExampleRules
  it "parses an ambiguous reply" do
    line = Token.tokenize( "yes no yes no no, Madam" )
    @rep.parse( line, nil ).should eq( [] )
    line.should eq( [",", "Madam"] )
  end
end
