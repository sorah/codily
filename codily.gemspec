# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'codily/version'

Gem::Specification.new do |spec|
  spec.name          = "codily"
  spec.version       = Codily::VERSION
  spec.authors       = ["Sorah Fukumori"]
  spec.email         = ["her@sorah.jp"]

  spec.summary       = %q{Codificate Fastly configuration}
  spec.homepage      = "https://github.com/sorah/codily"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "fastly"

  spec.add_development_dependency "bundler", ">= 1.12"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.0"
end
