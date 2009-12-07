require File.dirname(__FILE__) + '/../../spec_helper'

include Mingle4r::API
describe Murmur do
  it "should be able to concatenate the author name and the murmur body when printing a murmur" do
    Murmur.site = 'http://localhost:9090/projects/test'
    Murmur.user = 'testuser'
    Murmur.password = 'testuser'
    
    murmur = Murmur.new(:author => OpenStruct.new(:name => 'asur'),
    :body => 'my first murmur')
    murmur.to_s.should == 'asur - my first murmur'
  end
end