
# Define a HelloWorld pass
module PassModule

  Pass = Proc.new do |prog|

    puts "invoking test Pass"

    p prog

  end

end
