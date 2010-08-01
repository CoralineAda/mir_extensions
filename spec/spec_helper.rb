$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
ENV["RAILS_ENV"] = "test"
require File.dirname(__FILE__) + "/../config/environment" unless defined?(RAILS_ROOT)
require 'mir_extensions'
require 'spec'
require 'spec/autorun'

Spec::Runner.configure do |config|
  
end
