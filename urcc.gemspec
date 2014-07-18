# This file specifies the gem info for urcc

Gem::Specification.new do |s| 

  s.name        = "urcc"
  s.version     = "0.0.0"
  s.date        = "2014-07-11"
  s.license     = "LGPL v3"
  s.summary     = "URCC"
  s.description = "llvm tool in ruby"
  s.authors     = "C. Ding"
  s.bindir      = "bin"
  s.executables = ["urcc"]  
  s.files       = `git ls-files`.split("\n")  

end
