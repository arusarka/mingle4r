require 'rubygems'
require File.dirname(__FILE__) + '/../../lib/mingle4r'

Mingle4r::User.site = 'http://localhost:9090/projects/api_test'
Mingle4r::User.user = 'testuser'
Mingle4r::User.password = 'testuser'

users =  Mingle4r::User.find(:all)

puts users[0].user
