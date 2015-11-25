# -*- encoding: utf-8 -*-
require File.expand_path('../lib/omniauth-openam/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors = ["Edgars Beigarts"]
  gem.email = ["edgars.beigarts@gmail.com"]
  gem.description = "This is an OmniAuth provider for OpenAM's REST API"
  gem.summary = "An OmniAuth provider for OpenAM REST API"
  gem.homepage = "https://github.com/mak-it/omniauth-openam"
  gem.license = "MIT"

  gem.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name = "omniauth-openam"
  gem.require_paths = ["lib"]
  gem.version = OmniAuth::Openam::VERSION

  gem.add_dependency 'omniauth', '~> 1.0'
  gem.add_dependency 'faraday'

  gem.add_development_dependency 'rspec', '~> 2.7'
  gem.add_development_dependency 'rack-test'
  gem.add_development_dependency 'simplecov'
  gem.add_development_dependency 'webmock'
  gem.add_development_dependency 'syck'
  gem.add_development_dependency 'rake'
end
