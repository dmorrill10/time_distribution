# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'time_distribution/version'

Gem::Specification.new do |gem|
  gem.name          = "time_distribution"
  gem.version       = TimeDistribution::VERSION
  gem.authors       = ["Dustin"]
  gem.email         = ["morrill@ualberta.ca"]
  gem.description   = %q{Gem for creating time distribution management systems}
  gem.summary       = %q{Gem for creating time distribution management systems}
  gem.homepage      = ""
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "chronic", '~> 0.10'
  gem.add_dependency "chronic_duration", '~> 0.10'
  gem.add_dependency "ruby-duration", '~> 3.2'

  gem.add_development_dependency "rake", '~> 10.0'
  gem.add_development_dependency "awesome_print", '~> 1.6'
  gem.add_development_dependency "minitest", '~> 5.5'
  gem.add_development_dependency "pry-rescue", '~> 1.4'
  gem.add_development_dependency "simplecov", '~> 0.9'
end
