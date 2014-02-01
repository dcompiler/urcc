require 'grammar_rule.rb'

describe "Literal#parse" do
  it "checks for constant" do
    a = Literal[ "A" ]
    a.parse( "A" ).should eq( a )
  end
end

