require_relative 'token'

# The lookahead method finds the first Literal to choose the right
# parse.  The parse method succeeds and consumes the input.

class Rule
  attr_reader :input_type
  def initialize( type )
    raise "wrong input type #{type}" unless type == :file or type == :line
    @input_type = type
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
      result << r if not r.is_a? Literal
      input.next_line if @input_type == :file and not elem.is_a? RepRule
    end # sequence

    return result if @action == nil
    return @action.call( *result ) 
  end # parse
end # SeqRule


class SkipRule < Rule
  def initialize( input_type, symbol_after_end = [] )
    raise "SkipRule works for line only" if input_type == :file
    super( input_type )
    @symbol_after_end = symbol_after_end.is_a?(Array)? symbol_after_end : [ symbol_after_end ]
  end

  def lookahead( token )
    print "skip_look", token
    return self 
  end

  def parse( input )
    while input.line!=nil do
      print "skip ", input.line.shift
      return [] if @symbol_after_end.include?( input.line[0] )
    end
    return []
  end # parse
end # SkipRule


class RepRule < Rule # repetition rule: 0, 1, or more times
  # if [], repetition ends at the end of line or end of file
  def initialize( input_type, unit, symbol_after_end = [] )
    super( input_type )
    raise "need a SeqRule or AltRule" unless unit.class == SeqRule or unit.class == AltRule
    @kernel = unit
    @symbol_after_end = symbol_after_end.is_a?(Array)? symbol_after_end : [ symbol_after_end ]
  end

  def lookahead( token )
    if @kernel.lookahead( token ) == nil
      return @symbol_after_end.find{ |s| s == token }
    else
      return nil
    end
  end

  def parse( input )
#    result = []
#    if @input_type == :line
#        while input.line and not (input.line.empty? or @symbol_after_end.include?( input.line[0] ) or @symbol_after_end.include? (input.line[0][0])) do
#            p = @kernel.parse( input )
#            result.unshift( p ) unless p.is_a? Literal
#        end
#    else
#        while input.line do
#            if @symbol_after_end.include?( input.line[0] ) or (not input.line[0].empty? and @symbol_after_end.include? (input.line[0][0]))
#                #print 'unget', input.line[0], input.line[0][0]
#                print "end\n"
#                #input.unget_line
#                break
#            end
#
#            p = @kernel.parse( input )
#            result.unshift( p ) unless p.is_a? Literal
#            input.next_line if input.line.empty?
#        end
#    end
#    return result

    if input.line == nil or input.line.empty? or @symbol_after_end.include?( input.line[0] ) or @symbol_after_end.include? (input.line[0][0])
      return [ ] 
    end
    head = @kernel.parse( input )
    input.next_line if @input_type == :file and input.line and input.line.empty?
    rest = self.parse( input )
    rest.unshift( head ) unless head.is_a? Literal
    return rest
  end
end
