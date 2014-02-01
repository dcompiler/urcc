class IRNode
  attr_reader :name
  def initialize( str )
    @name = str
  end

  # The parser interface for all IRNodes
  def parse( line, file )
    return scan( line.shift )
  end
end

class LabelStmt < IRNode
  def scan( str )
    return nil unless str[-1..-1] == ':'
    return LabelStmt.new( str[0..-2] )
  end
end

# No Var object table because Var tables should function local.
#
class Var < IRNode
  attr_accessor :type
  def initialize( var, type = nil )
    @name, @type = var, type
  end

  def scan( str )
    return Var.new( str ) if str[0..0] == '%'
    return nil
  end
end
