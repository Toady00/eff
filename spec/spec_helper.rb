GEM_ROOT = File.expand_path("../../", __FILE__)
$:.unshift File.join(GEM_ROOT, "lib")

require 'rspec'
require 'pry-rescue/rspec'
require 'eff'

if ENV["TRAVIS"]
  require 'coveralls'
  Coveralls.wear!
else
  require 'simplecov'
end

Dir[File.join(GEM_ROOT, "spec", "support", "**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.order = "random"
end
