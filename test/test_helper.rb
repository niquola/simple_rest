def path(path)
  File.join(File.dirname(__FILE__),path)
end

$:.unshift(path('../lib'))
require 'rubygems'
require "test/unit"
require 'active_support'
require 'active_support/test_case'
require 'action_controller'
require 'simple_rest'

