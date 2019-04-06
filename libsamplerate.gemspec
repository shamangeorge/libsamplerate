# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'libsamplerate/version'

Gem::Specification.new do |spec|
  spec.name          = "libsamplerate"
  spec.version       = Libsamplerate::VERSION
  spec.authors       = ["shamangeorge"]
  spec.email         = ["shamangeorge@fruitopology.net"]

  spec.summary       = %q{ffi interface for libsamplerate}
  spec.description   = %q{Gem to interface with secret rabbit code}
  spec.homepage      = "https://github.com/shamangeorge/libsamplerate"
  spec.license       = "LGPL-3.0"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f|
    f.match(%r{^(test|spec|features)/}) || File.basename(f).start_with?(".")
  }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry", "~> 0.10"
  spec.add_development_dependency "rspec", "~> 3.5"
  spec.add_development_dependency "ffi_gen", "~> 1.2"
  spec.add_development_dependency "ruby-audio", "~> 1.6.1"
  spec.add_dependency "ffi", "~> 1.9"
end
