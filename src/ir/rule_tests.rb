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

module ExampleRules
  def initialize
    @alt = AltRule.new( :line ) do |a| 
      a.choices = [ Literal["yes"], Literal["NO!"] ]
      raise "identical choices found #{self}" unless a.choices.uniq.size == a.choices.size
    end
  end
end

describe "AltRule#parse" do
  include ExampleRules
  it "parses literals" do
    @alt.lookahead( "yes" ).should_not eq( nil )
    @alt.lookahead( "bluh" ).should eq( nil )
    line = [ "Yes", "Madam" ]
    file = nil
    @alt.parse( line, file ).should eq( Literal["yes"] )
  end    
end
