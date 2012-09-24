# -*- encoding: utf-8 -*-
require File.expand_path('../lib/igc/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["bbonamin"]
  gem.email         = ["bruno@bonamin.org"]
  gem.description   = 'Parses IGC files and exposes them as ruby objects'
  gem.summary       = 'Parses avionics IGC files from loggers and apps such as XCSoar and exposes them in a fancy object oriented way.'
  gem.homepage      = ""

  gem.add_development_dependency "rspec", '~> 2.11.0'
  
  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "igc"
  gem.require_paths = ["lib"]
  gem.version       = Igc::VERSION
end
