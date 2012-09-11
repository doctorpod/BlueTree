# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'blue_tree/version'

Gem::Specification.new do |s|
  s.name          = "blue_tree"
  s.version       = BlueTree::VERSION
  s.authors       = ["Andy White"]
  s.email         = ["andy@wireworldmedia.co.uk"]
  s.description   = %q{Build composite ERB templates}
  s.summary       = %q{Bluetree is a module of methods which allow you to create composable view 
classes. Each class instance is initialized with an ERB template. The 
templates of these views have access to all local instance variables and 
methods plus access to the immediate parent and root node objects.}
  s.homepage      = ""
  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]
  s.add_development_dependency "rspec", ">= 0"
end
