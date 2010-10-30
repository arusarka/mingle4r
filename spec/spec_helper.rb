require File.dirname(__FILE__) + '/../lib/mingle4r'
require 'test/unit'
require 'rspec/unit'
require 'yaml'

def load_fixture(file_name)
  file_path = File.join(File.expand_path(File.dirname(__FILE__)), 'fixtures', file_name)
  IO.read(file_path)
end
