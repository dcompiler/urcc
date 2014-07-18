require 'log'

describe "Log#info" do
  it "output info in the log file" do
    Log.info( "test" )
  end
end
