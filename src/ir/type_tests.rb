
require 'type'

describe "Type.str2type" do
  it "creates basic type objects" do
    int = Type.str2type( "i32" )
    int.should eq(Type.str2type( "i32" ) )
    int.name.should eq( "i32" )
    int.size.should eq( 32 )
  end

  it "creates pointer types" do
    intp = Type.str2type( "i32*" )
    intpp = Type.str2type( "i32**" )
    intp.name.should eq( "i32*" )
    intp.size.should eq( AddrType::AddrSize )
    intpp.deref.should eq( intp )
  end
end
    
