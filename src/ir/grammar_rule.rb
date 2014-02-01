require 'token'

# The lookahead method finds the first Literal to choose the right
# parse.  The parse method succeeds and consumes the input.

module InputParse
  attr_reader :input_type

  # return parsed line as an array
  def next_line( file )
    begin
      line = file.readline
    rescue EOFError
      return nil
    end
    line = Token.tokenize( line )
    return next_line( file ) if line == [ ]  # skip empty lines
    return line
  end # next_line
end

class Rule
  include InputParse
  def initialize( type )
    raise "wrong input type #{type}" unless type == :file or type == :line
    @input_type = type
  end

  # dive down until the first token
  def lookahead( token )
    return self if @subrule1.lookahead( token ) != nil

    return @subrule1.lookahead( token ) if @subrule1.is_a? Rule
    raise "invalid LL(1) grammar (the first elem must be a Literal)" unless @subrule1.is_a? Literal
    return @subrule1.check( token )
  end
end

class AltRule < Rule
  attr_accessor :choices
  def initialize( input_type, choices = nil )
    super( input_type )
    @choices = choices
    yield self if @choices == nil
    raise "identical choices found #{self}" unless @choices.uniq.size == @choices.size
  end

  def lookahead( token )
    match = nil
    @choices.each do |choice|
      r = choice.lookahead( token )
      raise "multiple matches found in AltRule #{self}" if r != nil and match != nil
      match = r if r != nil
    end

    return match
  end

  def parse( line, file )
    # choose the rule based on the first element, i.e. LL(1)
    choice = @choices.find{ |c| c.lookahead( line[0] ) != nil }
    raise "no rule found in AltRule #{@choices * ' '} for #{line * ' '}" if choice == nil
    return choice.parse( line, file )
  end # parse

end # AltRule

class SeqRule < Rule
  attr_reader :sequence, :action
  def initialize( input_type, sequence, &action )
    super( input_type )
    @sequence, @action = sequence, action
  end

  def lookahead( token )
    return @sequence[0].lookahead( token )
  end

  def parse( line, file )
# puts line # if @input_type == :file
    result = [ ]
    @sequence.each do |elem|
      r = elem.parse( line, file )
      result << r if not r.is_a? Literal
      line = next_line( file ) if @input_type == :file
    end # sequence

    return result if action == nil
    return action.call( *result ) 
  end # parse
end # SeqRule

class RepRule < Rule # repetition rule: 0, 1, or more times
  attr_reader :unit_rule
  # RepRule parses a file, while other rules parse a line.
  # if nil, repetition ends at the end of line or end of file
  def initialize( input_type, unit, symbol_after_end = [] )
    super( input_type )
    raise "need a SeqRule or AltRule" unless unit.class == SeqRule or unit.class == AltRule
    @unit_rule = unit
    @symbol_after_end = symbol_after_end.is_a?(Array)? symbol_after_end : [ symbol_after_end ]
  end

  def lookahead( token )
    if @unit_rule.lookahead( token ) == nil
      return @symbol_after_end.find{ |s| s == token }
    else
      return nil
    end
  end

  def parse( line, file )
    return [ ] if line == nil or @symbol_after_end.include?( line[0] )
    head = @unit_rule.parse( line, file )
    line = next_line( file ) if @input_type == :file
    rest = self.parse( line, file )
    rest.unshift( head ) unless head.is_a? Literal
    return rest
  end
end
