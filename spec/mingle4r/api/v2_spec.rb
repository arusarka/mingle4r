require File.dirname(__FILE__) + '/../../spec_helper'

describe Mingle4r::API::V2 do
  before(:each) do
    @api = Mingle4r::API::V2.new('http://localhost:8080')
  end
  it "should be able to initialize an instance with an url" do
    assert(@api)
  end
  
  it "should accept only valid url" do
    lambda {api = Mingle4r::API::V2.new('my project')}.should raise_error(Exception)
  end
  
  it "should be able to point to the appropriate base url" do
    @api.base_url.should == 'http://localhost:8080/api/v2'
  end
  
  it "should be able to say that the api version is 2" do
    @api.version.should == 2
  end
  
  it "should be able to point to the appropriate project class" do
    @api.project_class.should == Mingle4r::API::V2::Project
  end
  
  it "should be able to point to the appropriate user class" do
    @api.user_class.should == Mingle4r::API::V2::User
  end
end