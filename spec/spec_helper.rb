require 'rubygems'
require 'bundler/setup'

require 'apphealth'

require 'fakeweb'

RSpec.configure do |c|
  FakeWeb.allow_net_connect = false
end
