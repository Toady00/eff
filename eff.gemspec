# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'eff/version'

Gem::Specification.new do |spec|
  spec.name          = "eff"
  spec.version       = Eff::VERSION
  spec.authors       = ["Brandon Dennis"]
  spec.email         = ["toady00@gmail.com"]
  spec.description   = %q{Wrapper around fpm (effing package manager)}
  spec.summary       = %q{Wrapper around fpm (effing package manager)}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "fpm"
  spec.add_dependency "faraday"
  spec.add_dependency "typhoeus", "~> 0.6.7"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-plus"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "fakefs"
end
