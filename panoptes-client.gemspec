# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'panoptes/client/version'

Gem::Specification.new do |spec|
  spec.name          = "panoptes-client"
  spec.version       = Panoptes::Client::VERSION
  spec.authors       = ['Marten Veldthuis', 'Zach Wolfenbarger', 'Amy Boyer']
  spec.email         = ['marten@veldthuis.com', 'zach@zooniverse.org', 'amy@zooniverse.org']

  spec.summary       = %q{API wrapper for https://panoptes.zooniverse.org}
  spec.homepage      = "https://github.com/zooniverse/panoptes-client.rb"
  spec.license       = "Apache 2.0"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday"
  spec.add_dependency "faraday-panoptes", "~> 0.3.0"
  spec.add_dependency "jwt", "~> 1.5.0"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "timecop", "~> 0.8.0"
  spec.add_development_dependency "yard"
end
