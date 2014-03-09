require_relative 'token'
require_relative '../../misc/log'

# The lookahead method finds the first Literal to choose the right
# parse.  The parse method succeeds and consumes the input.

class Rule
  attr_reader :input_type
  def initialize( type )
    raise "wrong input type #{type}" unless type == :file or type == :line
    @input_type = type
    Log.info( " #{self.class} created #{self.to_s}" )
  end
end

class AltRule < Rule
  def initialize( input_type, choices = nil )
    super( input_type )
    @choices = choices
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

  def parse( input )
    # choose the rule based on the first element, i.e. LL(1)
    choice = @choices.find{ |c| c.lookahead( input.line[0] ) != nil }
    raise "no rule found in AltRule #{@choices * ' '} for #{input.line * ' '}" if choice == nil
    Log.info( "#{self} looks ahead #{ input.line[0] } and chooses #{choice}" )
    return choice.parse( input )
  end # parse

end # AltRule

class SeqRule < Rule
  def initialize( input_type, sequence, &action )
    super( input_type )
    @sequence, @action = sequence, action
  end

  def lookahead( token )
    return @sequence[0].lookahead( token )
  end

  def parse( input )
    result = [ ]
    @sequence.each do |elem|
      # puts "line: #{input.line * ' '}" if @input_type == :file and input.line != nil
      r = elem.parse( input )
      #result << r if not r.is_a? Literal
      result << r
      input.next_line if @input_type == :file and not elem.is_a? RepRule
    end # sequence

    return result if @action == nil
    return @action.call( *result ) 
  end # parse
end # SeqRule

class RepRule < Rule # repetition rule: 0, 1, or more times
  # if [], repetition ends at the end of line or end of file
  def initialize( input_type, unit, symbol_after_end = [], terminate_cond = nil )
    super( input_type )
    raise "need a SeqRule or AltRule" unless unit.class == SeqRule or unit.class == AltRule
    raise "terminate condition should be a lamba" if terminate_cond and not terminate_cond.lambda?
    @kernel = unit
    @symbol_after_end = symbol_after_end.is_a?(Array)? symbol_after_end : [ symbol_after_end ]
    @tcond = terminate_cond
  end

  def lookahead( token )
    if @kernel.lookahead( token ) == nil
      return @symbol_after_end.find{ |s| s == token }
    else
      return nil
    end
  end

  def parse( input )
    if input.line == nil or input.line.empty? or @symbol_after_end.include?( input.line[0] ) or @symbol_after_end.include? (input.line[0][0]) or (@tcond and @tcond.call(input.line[0]))
      return [ ] 
    end
    head = @kernel.parse( input )
    input.next_line if @input_type == :file and input.line and input.line.empty?
    rest = self.parse( input )
    rest.unshift( head ) unless head.is_a? Literal
    return rest
  end
end
