
# Every word in an input is a token.  Token subclasses should be
# disjoint subsets of strings.
 
class Token
  attr_reader :tname
  def initialize( str )
    @tname = str
  end
end

class << Token
  # The parser interface for all Token child classes except for Literal.
  # First use of meta-class inheritance by CD, on 2/1/2014.
  def parse( line, file )
    return scan( line.shift )
  end

  def tokenize( str )
    # should find brackets/parentheses first
    # remove the comment if any
    str = str[0...str.index(";")] if str.index(";") != nil
    str = str.split
    elems = [ ]
    str.each do |e|
      if e[-1..-1] != ','
        elems << e
      else
        elems << e[0..-2]
        elems << ','
      end
    end # comma fixing
    return elems
  end
end

class Text < Token
end

class << Text
  # In theory, a Text token is a text string that is not a
  # Literal. But the Literal table is built incrementally, so we use
  # text cues.
  def scan( str )
    return str if ["%", "@", "i"].include? str[0..0]
    return nil
  end
end

class Number < Token
end

class << Number
  def scan( str )
    return nil unless str.match /^[0-9]*[.]?[0-9]*$/
    return str.to_f if str.match /^[0-9]*[.][0-9]*$/
    return str.to_i
  end
end

class Str < Token
end

# Literal is different from other Tokens.  In the grammar
# specification, a Literal is a Literal object but other Tokens are
# classes.
class Literal < Token
  def lookahead( token )
    return self if @tname == token.downcase
    return nil
  end

  def parse( line, file )
    token = line.shift
    return self if @tname == token.downcase
    raise "#{@tname} literal expected but have #{str}"
  end
end

class << Literal
  attr_reader :lits
  def []( str )
    @lits = Hash.new if @lits == nil
    str.downcase!
    @lits[ str ] = Literal.new( str ) if @lits[ str ] == nil
    return @lits[ str ]
  end
end

