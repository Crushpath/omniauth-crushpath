$:.unshift File.expand_path('..', __FILE__)
$:.unshift File.expand_path('../../lib', __FILE__)
require 'simplecov'
SimpleCov.start
require 'rspec'
require 'rack/test'
require 'webmock/rspec'
require 'omniauth'
require 'omniauth-crushpath'
require 'json'
require_relative "../lib/crushpath_api/user_response"

RSpec.configure do |config|
  config.include WebMock::API
  config.include Rack::Test::Methods
  config.extend  OmniAuth::Test::StrategyMacros, :type => :strategy
end

def fixture_path
  File.expand_path("../fixtures", __FILE__)
end

def fixture(file, read=false)
  file = File.new(fixture_path + '/' + file)
  return JSON.parse(File.read(file)) if read
  file
end