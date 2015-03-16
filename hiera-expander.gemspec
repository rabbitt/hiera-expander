# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hiera/backend/expander'

Gem::Specification.new do |spec|
  spec.name          = "hiera-expander"
  spec.version       = Hiera::Expander::VERSION
  spec.authors       = ["Carl P. Corliss"]
  spec.email         = ["rabbitt@gmail.com"]
  spec.summary       = %q{Hiera backend that causes each data source to be expanded into multi-level sources.}
  spec.homepage      = "https://github.com/rabbitt/hiera-expander"
  spec.license       = "GPLv2"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
