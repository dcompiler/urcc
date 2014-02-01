require 'irnode'

class Literal < IRNode
  def parse( str )
    return self if @name == str
    return nil
  end

  def match( str )
    return self if @name == str
    raise "#{@name} literal expected but have #{str}"
  end
end

class << Literal
  def []( str )
    @lits = Hash.new if @lits == nil
    @types[ str ] = Literal.new( str ) if @types[ str ] == nil
    return @types[ str ]
  end
end

module InputParse
  attr_reader :input_type

  def set_input_type( type )
    raise "wrong input type #{type}" unless type == :file or type == :line
    @input_type = type
  end

  # return parsed line as an array
  def next_line( line, file )
    line = file.readline
    # remove the comment if any
    line = line[0...line.index(";")] if line.index(";") != nil
    line = line.split
    elems = [ ]
    line.each do |e|
      if e[-1..-1] != ','
        elems << e
      else
        elems << e[0..-2]
        elems << ','
      end
    end # comma fixing
    return elems
  end # next_line
end

class AltRule
  attr_reader :choices
  def initialize
    @choices = [ ]
    yield @choices
  end

  def parse( line, file )
    # choose the rule based on the first element, i.e. LL(1)
    chosen = nil
    str = line[0]
    @choices.each do |rule|
      raise "SeqRule expected" unless rule.class == SeqRule
      match = nil
      if rule.input_type == :file
        match = rule.sequence[0].parse( line.clone, file )
      else
        match = rule.sequence[0].parse( str, file )
      end
      if match != nil
        if chosen != nil
          chosen = rule
        else
          raise "multiple matches, #{chosen} and #{rule}"
        end
      end # match
    end # choices

    return chosen.parse( line, file )
  end # parse
end # AltRule

class SeqRule
  attr_reader :sequence, :action
  def initialize( sequence, &action )
    @sequence, @action = sequence, action
  end

  def parse( line, file )
    result = [ ]
    @sequence.each do |elem|
      case # elem  # checking the class using the === operator
        when elem.is_a?(Literal)
          str = line.shift
          elem.match( str )
        when (elem.is_a?(AltRule) or elem.is_a?(RepRule)) 
          # raise "need a :line rule" unless elem.input_type == :line
          # line is consumed in place and changed when return
          result << elem.parse( line, file )
          raise "error" unless result[-1] != nil
        else
          # elem must be an IRNode
          raise "#{elem} is not an IRNode" unless elem.is_a?( IRNode )
          str = line.shift
          result << elem.parse( str )
      end # case
    end # sequence

    return action.call( *result )
  end # parse
end # SeqRule

class RepRule  # repetition rule
  include InputParse
  attr_reader :unit_rule
  # RepRule parses a file, while other rules parse a line.
  # if nil, repetition ends at the end of line or end of file
  def initialize( unit, symbol_after_end = [] )
    raise "need a SeqRule or AltRule" unless unit.class == SeqRule or unit.class == AltRule
    @unit_rule = unit
    @symbol_after_end = symbol_after_end
  end

  def parse( line, file )
    return [ ] if line == nil or symbol_after_end.include?( line[0] )
    head = @unit_rule.parse
    line = next_line( file )
    rest = self.parse( line, file )
    rest.unshift( head )
    return rest
  end
end
