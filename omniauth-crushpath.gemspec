# -*- encoding: utf-8 -*-
require File.expand_path('../lib/omniauth-crushpath/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Monica Wilkinson"]
  gem.email         = ["ciberch@crushpath.com"]
  gem.description   = "Provides a bearer token with which to invoke the Crushpath Deals API"
  gem.summary       = %q{OmniAuth strategy for Crushpath}
  gem.homepage      = "https://deals.crushpath.com"

  gem.rubyforge_project = "omniauth-crushpath"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "omniauth-crushpath"
  gem.require_paths = ["lib"]
  gem.version       = OmniAuth::Crushpath::VERSION


  gem.add_runtime_dependency 'omniauth-oauth2',    '>= 1.1'

  gem.add_development_dependency 'rspec',     '>= 2.7'
  gem.add_development_dependency 'rack-test'
  gem.add_development_dependency 'simplecov'
  gem.add_development_dependency 'webmock'
end
