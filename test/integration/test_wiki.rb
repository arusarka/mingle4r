require 'rubygems'
require File.dirname(__FILE__) + '/../../lib/mingle4r'

m_c = Mingle4r::MingleClient.new('http://localhost:9090', 'testuser', 'testuser', 'api_test')

proj = m_c.project
puts proj.wiki.size