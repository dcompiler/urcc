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
    if not options.filename.end_with?(".c")
      puts "Unsupported filetype, please input a c file"

      exit
    end

  end

  return options

end


# read in config file, return config info
def parse_config( config_path )
  begin
    config = ParseConfig.new( config_path )
  rescue
    puts "No config file specified, using default config"

    # default config
    d_config = Hash.new
    d_config["CC"] = Hash.new
    d_config["CC"]["cc"] = "clang"
    d_config["CC"]["opt"] = "opt"
    d_config["CC"]["clang_path"] = "/usr/bin/clang"
    d_config["CC"]["opt_path"] = "/usr/bin/opt"

    return d_config
  end

  return config.params

end


# wrapper for excute
def execute( cmd )
  puts "#{cmd}"
  `#{cmd}`
end


# execute passes
def passes( prog, pass )


end



##################################
# Main function for urcc 
##################################
def main

  # read args
  options = parse_args(ARGV)
  filename = options.filename
  filechomp = filename.chomp(".c")


  # read config for cc version and path
  config_path = 'urcc.config'
  config = parse_config( config_path )


  # run cc to dump ir file
  cc = config["CC"]["cc"]
  opt = config["CC"]["opt"]
  cc_flag = "-O0 -emit-llvm"
  # TODO: why add reg2mem pass?
  opt_flag = "-reg2mem -S" 
  bitcode_file = "#{filechomp}.ll"
  execute "#{cc} #{cc_flag} -c #{filename} -o - | #{opt} #{opt_flag} -o #{bitcode_file}"

 
  # parse bitcode file with URCCFE to get AST representation
  prog = URCCFE.new(bitcode_file).astroot

  ##################################
  # run PASSes
  ##################################
  passes = config["PASS"]["pass"].split(",")

  if not passes.empty?
    passes.each do |passname|

      # require pass
      begin
        passname.strip!
        pass_path = File.join(config["PATH"]["pass_path"], passname)

        if defined?(Pass)
          PassModule.send(:remove_const, "Pass")
        end
        require_relative( pass_path )
        include( PassModule )

      rescue Exception => e
        p e
        puts "Error loading pass #{passname}"
      end

      # output prog
      puts "-------------------------"
      puts "Invoking #{passname} Pass"
      puts "-------------------------"
      PassModule::Pass.call( prog )

      puts "\n"
    end
  end


  # run URCCFE to dump opted version
  opt_file = filechomp + "_urcc_opt.c"
  f = File.new(opt_file, "w")
  f << URCCFE.dump_prog(prog)
  f.close

  # run cc to compile again
  opt_bin = filechomp + ".bin"
  
  cc = config["CC"]["cc"]
  opt = config["CC"]["opt"]
  cc_flag = "-O0 -Wno-format-security -Wno-implicit-function-declaration"
  execute "#{cc} #{cc_flag} -g #{opt_file} -o #{opt_bin}"


end




# Run main 
if __FILE__ == $0

  main

end
