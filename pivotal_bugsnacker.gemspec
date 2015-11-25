# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pivotal_bugsnacker/version'

Gem::Specification.new do |spec|
  spec.name          = "pivotal_bugsnacker"
  spec.version       = PivotalBugsnacker::VERSION
  spec.authors       = ["Karl Baum"]
  spec.email         = ["karl.baum@gmail.com"]
  spec.summary       = %q{Reads bugs from bugsnag and updates linked pivotal tracker ticket with meta data}
  spec.description   = %q{Reads bugs from bugsnag and updates linked pivotal tracker ticket with meta data}
  spec.homepage      = "https://github.com/viewthespace/pivotal_bugsnacker"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"
  spec.add_dependency 'bugsnag-api'
  spec.add_dependency 'tracker_api'
  spec.add_dependency 'multi_json'
  spec.add_dependency 'redis'
end
