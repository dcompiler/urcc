#!/usr/bin/ruby

##################################
# The main exec script for urcc
# 
##################################

require "parseconfig"
require "optparse"
require "ostruct"
require "pp"

# The urcc frontend
require "../lib/ir/urccfe.rb"

##################################
# Helper function definition
##################################

# parse input arg with optparse
def parse_args( args )
  
  options = OpenStruct.new
  options.inplace = false
  options.encoding = "utf-8"
  options.transfer_type = :auto
  options.verbose = false
  options.version = "0.0.0"

  # construct parser
  opt_parser = OptionParser.new do |opts|
    opts.banner = "Usage: urcc <filename> [options]"
    opts.separator ""

    # option directory
    opts.on("-d", "--dir DIR",
            "Target directory") do |dir|
      options.dir = dir
    end

    opts.on("-S", "--asm",
            "Assemble to ir") do |ver|
      options.asm = true
    end

    opts.on("-v", "--version",
            "Print version number") do |v|
      puts options.version
      exit
    end

    opts.on("-h", "--help",
            "Print this message") do |h|
      puts opts
      exit
    end

  end

  opt_parser.parse!( args )

  # specify input filename
  if args.empty?
    puts "Error: No file input. Please specify a c file."
    puts opt_parser
    exit
  else
    options.filename = args.pop
  end

  return options

end


# read in config file, return Hash with info
def read_conf( config_path )

  

end


# wrapper for excute
def exec( cmd )
  puts "#{cmd}"
  `#{cmd}`
end


# execute passes
def passes( prog, pass )


end



##################################
# The main function for urcc 
##################################
def main

  # read args
  options = parse_args(ARGV)

  pp options
  
  # read config for cc version and path
  config_path = 'urcc.config'

  parse_config( config_path )

  # run cc to dump ir file


  # run URCCFE to parse AST representation


  # run PASSes


  # run URCCFE to dump opted version



  # run cc to compile again


end




# Run main 
if __FILE__ == $0

  main

end
