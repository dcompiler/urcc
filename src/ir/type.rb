
class Type
  attr_reader :name, :size # size in bits
  private
  def initialize( name, size )
    @name, @size = name, size
  end
end

class << Type
  def str2type( str )
    init_base_types if @types == nil
    return @types[ str ] if @types[ str ] != nil
    if str[-1] = '*'
      deref = str[0..-2]
      @types[ str ] = AddrType.new( str, Type.str2type( deref ) )
    end
    return @types[ str ]
  end

  private
  def init_base_types
    @types = Hash.new
    @types = {
      "i32" => Type.new( "i32", 32 ),
      "i1" => Type.new( "i1", 1 )
    }
  end
end
    
class AddrType < Type
  attr_reader :deref  # type after de-reference
  AddrSize = 32
  private
  def initialize( name, deref )
    @name, @size = name, AddrSize
    @deref = deref
  end
end
