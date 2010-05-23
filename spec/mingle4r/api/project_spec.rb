require File.dirname(__FILE__) + '/../../spec_helper'

include Mingle4r::API

describe Project do
  before do
    Project.site     = 'http://localhost/api/v2/'
    Project.user     = 'test'
    Project.password = 'test'
  end
  
  context "fetching cards" do
    it "should set the attributes for User class only once" do
      project = Project.new(:identifier => 'some-id')
      
      User.stub!(:find)
      User.should_receive(:site=).once
      project.users
      project.users
    end
  end
end
