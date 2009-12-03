$:.unshift File.expand_path(File.dirname(__FILE__))

require 'logger'
require 'rubygems'
require 'active_resource'
require 'net/http'

# This module should be used to interact with mingle. Look in the readme for examples.
module Mingle4r
  AUTHOR = 'Asur'
end

require 'mingle_resource'
require 'mingle4r/version'
require 'mingle4r/common_class_methods'
require 'mingle4r/common_dyn_class_instance_methods'
require 'mingle4r/helpers'
require 'mingle4r/mingle_client'
require 'mingle4r/api'

# Version 1 of api
require 'mingle4r/api/v1'
require 'mingle4r/api/v1/card'
require 'mingle4r/api/v1/card/attachment'
require 'mingle4r/api/v1/project'
require 'mingle4r/api/v1/property_definition'
require 'mingle4r/api/v1/user'
require 'mingle4r/api/v1/wiki'

# version 2 of api
require 'mingle4r/api/v2'
require 'mingle4r/api/v2/card'
require 'mingle4r/api/v2/card/comment'
require 'mingle4r/api/v2/card/transition'
require 'mingle4r/api/v2/project'
require 'mingle4r/api/v2/property_definition'
require 'mingle4r/api/v2/user'
require 'mingle4r/api/v2/wiki'
