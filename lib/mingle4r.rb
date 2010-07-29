$:.unshift File.expand_path(File.dirname(__FILE__))

require 'logger'
require 'rubygems'
require 'active_resource'
require 'net/http'

# This module should be used to interact with mingle. Look in the readme for examples.
module Mingle4r; end

require 'mingle_resource'
require 'mingle4r/common_class_methods'
require 'mingle4r/helpers'
require 'mingle4r/mingle_client'
require 'mingle4r/card_format'

require 'mingle4r/api/card'
require 'mingle4r/api/card/attachment'
require 'mingle4r/api/card/comment'
require 'mingle4r/api/card/transition'
require 'mingle4r/api/execute_mql'
require 'mingle4r/api/murmur'
require 'mingle4r/api/project'
require 'mingle4r/api/property_definition'
require 'mingle4r/api/user'
require 'mingle4r/api/wiki'
