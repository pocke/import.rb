# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'import'

Gem::Specification.new do |spec|
  spec.name          = "import.rb"
  spec.version       = Import::VERSION
  spec.authors       = ["Masataka Kuwabara"]
  spec.email         = ["p.ck.t22@gmail.com"]

  spec.summary       = "Instead of Kernel.require"
  spec.description   = "Instead of Kernel.require"
  spec.homepage      = "https://github.com/pocke/import.rb"
  spec.license       = 'CC0-1.0'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "test-unit", "~> 3.1.5"
  spec.add_development_dependency "guard", "~> 2.13.0"
  spec.add_development_dependency "guard-test", "~> 2.0.6"
  spec.add_development_dependency "pry", "~> 0.10.2"
end
