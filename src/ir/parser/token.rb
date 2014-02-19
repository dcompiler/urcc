
# Every word in an input is a token.  Token subclasses should be
# disjoint subsets of strings.
 
class Token
  attr_reader :tname
  def initialize( str )
    @tname = str
  end

  # Input stream class.  Only one object for a file.
  class Input
    attr_reader :line
    def initialize( file )
      @file = file
      @unget_once = false
      @last_line = nil
      next_line
    end

    # a line is an array of words
    def next_line
      begin
        if @unget_once == true
          @unget_once = false
        else
          @last_line = @file.readline
        end
        @line = Token.tokenize( @last_line )
        next_line if @line == [ ]  # skip empty lines
      rescue EOFError
        @line = nil
      end
    end # next_line

    def unget_line
      begin
        @unget_once = true
      end
    end
  end # Token::Input
end # Token

class << Token
  # The parser interface for all Token child classes except for Literal.
  # First use of meta-class inheritance by CD, on 2/1/2014.
  def parse( input )
    return scan( input.line.shift )
  end

  def lookahead( token )
    return scan( token )
  end
  
  def _split( strs, del ) 
    elems = [ ]
    strs.each do |e|
      pos = e.index(del)
      if pos 
        elems << e[0..pos-1] if pos != 0
        elems << del
        elems << e[pos+1..-1] if pos != e.length-1
      else
        elems << e
      end
    end
    return elems
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
    elems = _split(elems, '(')
    elems = _split(elems, ')')
    print elems, "\n"
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
    return nil unless str.match /^[-+]?[0-9]*[.]?[0-9]*$/
    return str.to_f if str.match /^[-+]?[0-9]*[.][0-9]*$/
    return str.to_i
  end
end

class Label < Token
end

class << Label
  def scan( str) 
    return str if str[-1]==":" # label
    return nil
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

  def parse( input )
    token = input.line.shift
    return self if @tname == token.downcase
    raise "'#{@tname}' literal expected but have '#{token.downcase}'"
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

