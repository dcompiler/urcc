
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
      next_line
    end

    # a line is an array of words
    def next_line
      begin
        @line = Token.tokenize( @file.readline )
        next_line if @line == [ ]  # skip empty lines
      rescue EOFError
        @line = nil
      end
    end # next_line

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
  
  def split_keep_str( line )
    if line.index('"')
      b = line.index('"') -1 
      e = line.rindex('"') # assume only one string
      elems = line[0..b-1].split
      elems << line[b..e]
      elems += line[e+1..-1].split
      return elems
    end
    return line.split
  end

  def _split( strs, del )
    elems = [ ]
    strs.each do |e|
      pos = nil
      pos = e.index(del) if not e.start_with? 'c"'
      if pos and e.length>1 
        ne = []
        ne << e[0..pos-1] if pos != 0
        ne << del
        ne << e[pos+1..-1] if pos != e.length-1
        elems += _split(ne, del)
      else
        elems << e
      end
    end
    return elems
  end

  def _split_right( strs, del )
    elems = [ ]
    strs.each do |e|
      if del.include? e[-1] and not e.start_with? 'c"' and e.length > 1
        elems << e[0..-2]
        elems << e[-1]
      else
        elems << e
      end
    end
    return elems
  end

  def tokenize( str )
    # should find brackets/parentheses first
    # remove the comment if any
    str = str[2..-1] if str[0] == ';' and str[2..-1].start_with? "<label>:"
    str = str[0...str.index(";")] if str.index(";") != nil
    str = "" if str[0] == ("!") # ignore metadata
    #p = str.index('"')
    #str = p ? str[0..p].split.push(str[p..-1]) : str.split
    elems = split_keep_str(str)
    elems = _split(elems, '(')
    elems = _split(elems, ')')
    elems = _split(elems, '*')
    elems = _split(elems, '[')
    elems = _split_right(elems, [','])
    elems = _split_right(elems, [']'])
    #print 'token ', elems, "\n"
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
    return 1 if str == "true"
    return 0 if str == "false"
    return nil unless str.match /^[-+]?[0-9]*[.]?[0-9]+([eE][-+]?[0-9]+)?$/
    return str.to_f if str.match /^[-+]?[0-9]*[.][0-9]+([eE][-+]?[0-9]+)?$/
    return str.to_i
  end
end

class Label < Token
end

class << Label
  def scan( str) 
    return str[0..-2] if str[-1] == ':'
    return str.split(':')[-1] if str.start_with? '<label>:' # label
    return nil
  end
end

class Str < Token
end

class << Str
  def scan ( str )
    return nil if not str.start_with? "c\""
    str = str.gsub('\00', '')
    str = str.gsub('\0A', '\n')
    return str[2..-2]
  end
end

class Any < Token
end

class << Any
  def scan( str ) 
    return str if str!=nil and !str.empty? 
    return nil
  end
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

