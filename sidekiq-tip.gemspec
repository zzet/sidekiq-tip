# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sidekiq/tip/version'

Gem::Specification.new do |spec|
  spec.name          = "sidekiq-tip"
  spec.version       = Sidekiq::Tip::VERSION
  spec.authors       = ["Andrew Kumanyaev"]
  spec.email         = ["me@zzet.org"]
  spec.summary       = %q{Perform worker in time interval}
  spec.description   = %q{Sometimes we need to perform some workers in time interval. For example, we want to run all jobs at night (from 2 am to 6 am).}
  spec.homepage      = "https://github.com/zzet/sidekiq-tip"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
