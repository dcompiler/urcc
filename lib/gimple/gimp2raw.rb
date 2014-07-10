#!/usr/bin/ruby

# One entry for each gimple node, which starts with "@"
class RawEntry
  attr_reader :rawType, :rawID
  attr_accessor :attributes
  def initialize(id, type)
    @rawID = id
    @rawType = type
    @attributes = Hash.new
  end

  def Dump
    dumpstr = "#{@rawID.to_s} #{@rawType}\n"
    @attributes.each { |k,v| dumpstr += "#{k}: #{v}, "}
    dumpstr[-2..-1] = " \n"
    print dumpstr
  end
end

class RawFunc
  attr_reader :name, :paramList, :rawEntries
  def initialize(name, paramList)
    @rawEntries = Array.new
    @rawEntries[0] = nil #Index 0 of this array is not used
    @name = name
    @paramList = paramList.split(/, /) 
  end

  def Append_RawEntry(id, type)
    #id will be a string like "@4", let's check the id
    raise "Found ID number inconsistency!" if @rawEntries.size != (id[1..-1]).to_i
    @rawEntries[@rawEntries.size] = RawEntry.new(@rawEntries.size, type)
  end 
  
  def Get_RawEntry(id)
    if id.is_a?(String) and id[0].chr == "@" then
      return @rawEntries[id[1..-1].to_i]
    elsif id.is_a?(Integer) then
      return @rawEntries[id]
    else
      nil
    end
  end
  
  def Get_RawType(id)
    return Get_RawEntry(id).rawType
  end
  
  def Get_Attribute(id, name)
    return Get_RawEntry(id).attributes[name]  
  end
  
  # Given a raw entry id, return its name attribute as a string
  def Get_Name(id)    
    node = Get_RawEntry(id)
    if node.attributes["name"] then
      return Get_Name(node.attributes["name"])
    elsif node.attributes["strg"] then
      return node.attributes["strg"]
    else
      return nil
    end
  end
  
  # Given a raw entry id, return the name of its type attribute
  def Get_Type(id)
    tid = Get_RawEntry(id).attributes["type"]
    if Get_RawEntry(tid).rawType == "pointer_type" then
      return Get_Pointer_Type(tid)
    elsif Get_RawEntry(tid).rawType == "array_type" then
      return Get_Array_Type(tid)
    else
      return Get_Name(tid)
    end
  end

  # Return a pointer type, something like "int*"
  def Get_Pointer_Type(id)
    nid = Get_RawEntry(id).attributes["ptd"]
    if Get_RawEntry(nid).rawType == "pointer_type" then
      return Get_Pointer_Type(nid)+"*"
    else
      return Get_Name(nid)+"*"
    end      
  end
  
  # elts points to a type or another array_type
  def Get_Array_Type(id)
    eid = Get_RawEntry(id).attributes["elts"]
    if Get_RawEntry(eid).rawType == "array_type" then
      return Get_Array_Type(eid)+Get_Dimension(id)
    else
      return Get_Name(eid)+Get_Dimension(id)
    end      
    
  end
  
  # auxiliary function to get the upper bound of array dimension
  def Get_Dimension(id)
    nid = Get_RawEntry(id).attributes["domn"]
    nid = Get_RawEntry(nid).attributes["max"]
    ub = Get_RawEntry(nid).attributes["low"].to_i
    ub = ub + 1 # C array starts at index 0
    return "[#{ub.to_s}]"        
  end
  

  def Dump
    puts @name + "(" + @paramList.join(", ")  + ")"
    1.upto(@rawEntries.size-1) { |i| @rawEntries[i].Dump }
  end
end

# class to parse a gimple raw dump file, which is dump by gcc using 
# "-O0 -fdump-tree-gimple-raw" flag.
class Gimple2Raw
  attr_reader :funcList
  def initialize(file)
    @fileHandle = File.new(file, "r")
    @funcList = Array.new
    Parse()
  end

  def Dump
    @funcList.each { |e| e.Dump }
  end

  def Parse
    while not @fileHandle.eof?
      line = @fileHandle.readline
      ParseLine(line)
    end
    @fileHandle.close
  end
  
  # Parse each line
  def ParseLine(line)
    if line[0].chr != " " and line[0].chr != "@" then
      # If this line does no start with a space or "@", then we
      # find a function declaration
      funcName = line[/.*\s\(/] #retrieve function name, e.g. "foo ("  
      paramList = line[/\(.*\)/] #retrieve parameters, e.g. "(a, b)"
      @funcList[@funcList.size] = RawFunc.new(funcName[0..-3], paramList[1..-2])
    else
      if line[0].chr == "@" then
        # Find a new RawEntry 
        words = line.split
        id = words[0]
        type = words[1]
        @funcList[-1].Append_RawEntry(id, type)
        Add_Attributes(line[line.index(type)+type.length..-1])      
      else
        # If this line starts with a space, we assume this is going to  
        # continue with the previous line, which contains more attributes.
        Add_Attributes(line)
      end
    end
  end
  
  def Add_Attributes(line)
    i = 0
    words = line.split
    while i < words.size do
      # The common case, attribute name + value
      if words[i][-1].chr == ":" then      
        if words[i] == "strg:" then
          # "strg:" need special processing
          i = Add_Strg_Attribute(line)
        else
          Add_Single_Attribute(words[i].chop, words[i+1])
          i += 2
        end
        
      # A special case like "op 0: @9"
      elsif words[i] == "op" then
        if words[i+1][-1].chr == ":" then
          Add_Single_Attribute(words[i]+words[i+1].chop, words[i+2])
          i += 3
        else
          raise "ERROR 1: Illegal gimple raw file format.\n #{line}"
        end
                
      # There are some spaces between the attribute name and ":"
      else        
        if words[i+1] == ":" then
          Add_Single_Attribute(words[i], words[i+2])
          i += 3
        else
          raise "ERROR 2: Illegal gimple raw file format.\n #{line}"
        end
      end
    end #while 
  end
  
  def Add_Single_Attribute(name, value)  
    @funcList[-1].rawEntries[-1].attributes[name] = value
  end 
  
  # Special case: all words after "strg:" will be its value until we
  # meet "lngt:". The value of "lngt:" will indicate the actual length
  # of the string. We need that value to trucate the string we get.
  # Precondition: assume the actual string does not contain "lngt:"  
  def Add_Strg_Attribute(line)
    words = line.split
    strg = line[/strg:.*lngt:/]
    i = words.index("lngt:")
    
    # This logic highly depends on gimple raw format
    if not i then
      # store the return value, to terminate the while loop calling this function
      res = words.size

      # "lngt:" is missing because the string contains a "\n"
      # we need to explicitly add this back
      strg = line[/strg:.*/][6..-1]+"\\n"
      
      num_newline = 0
      line = @fileHandle.readline
      while not line[/lngt:/]
        # line[-1].chr will be "\n" in this case
        strg = strg + line[0..-2] + "\\n"
        num_newline += 1
        line = @fileHandle.readline
      end
      strg = strg + line[/.*lngt:/][0..-8]
          
      words = line.split
      # somehow, the "\n" in the middle of a string is only counted as length 1.
      # e.g. length of "hi\nhi\nhi\n" is 12, but it is only 10 in "lngt"
      length = words[words.index("lngt:")+1]
      Add_Single_Attribute("strg", strg[0..(length.to_i + num_newline - 1)])
      Add_Single_Attribute("lngt", length)

      return res 
    else
      lngt = words[i+1].to_i
      if strg[6+lngt-1].chr == " " then
        #TODO: This is just a workaround. If the last character of this string is
        # a space, we can ignore it. This is to deal with the extra space at the
        # end of a string, introduced by GCC gimple dump. 
        # This hack will not case any problem if the string is a variable name.
        Add_Single_Attribute("strg", strg[6..6+lngt-2])
      else
        Add_Single_Attribute("strg", strg[6..6+lngt-1])
      end
      Add_Single_Attribute("lngt", words[i+1])
      return i+2
    end
  end  
end #RawGimpleParser
