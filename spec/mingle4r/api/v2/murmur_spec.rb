require File.dirname(__FILE__) + '/../../../spec_helper'

describe Mingle4r::API::V2::Murmur do
  it "should be able to concatenate the user and the murmur when printing a murmur" do
    Mingle4r::API::V2::Murmur.site = 'http://localhost:9090/projects/test'
    Mingle4r::API::V2::Murmur.user = 'testuser'
    Mingle4r::API::V2::Murmur.password = 'testuser'
    
    murmur = Mingle4r::API::V2::Murmur.new(:author => OpenStruct.new(:name => 'asur'),
    :body => 'my first murmur')
    murmur.to_s.should == 'asur - my first murmur'
  end
end