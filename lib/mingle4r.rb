$:.unshift File.expand_path(File.dirname(__FILE__))

require 'logger'
require 'rubygems'
require 'active_resource'
require 'net/http'

# This module should be used to interact with mingle. Look in the readme for examples.
module Mingle4r
end

require 'mingle_resource'
require 'mingle4r/version'
require 'mingle4r/common_class_methods'
require 'mingle4r/common_dyn_class_instance_methods'
require 'mingle4r/helpers'
require 'mingle4r/user'
require 'mingle4r/card'
require 'mingle4r/project'
require 'mingle4r/property_definition'
require 'mingle4r/wiki'
require 'mingle4r/mingle_client'