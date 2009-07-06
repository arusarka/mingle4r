$:.unshift File.expand_path(File.dirname(__FILE__))

require 'logger'
require 'rubygems'
require 'active_resource'
require 'net/http'

module Mingle4r
  AUTHOR = 'Asur'
  VERSION = '0.0.1'
end

require 'mingle_resource'
require 'mingle4r/common_class_methods'
require 'mingle4r/helpers'
require 'mingle4r/card'
require 'mingle4r/project'
require 'mingle4r/mingle_client'
