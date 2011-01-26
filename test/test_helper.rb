def path(path)
  File.join(File.dirname(__FILE__),path)
end

$:.unshift(path('../lib'))
require 'rubygems'
require "test/unit"
require 'rails'
require "action_controller"
require "action_dispatch/routing"
#require 'rails/application/configuration'
require 'simple_rest'

