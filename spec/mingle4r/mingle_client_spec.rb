require File.dirname(__FILE__) + '/../spec_helper'

include Mingle4r
describe MingleClient do
  before(:each) do
    @client = MingleClient.new('http://localhost', 'test', 'test', 'project')
  end
  
  it "should call the Project class to fetch the project" do
    API::Project.should_receive(:find).with('project')
    @client.project
  end
  
  it "should check whether the credentials given are valid or not by fetching the project resources" do
     API::Project.should_receive(:find).with(:all)
     @client.valid_credentials?
  end
  
  it "should set the appropriate attributes in the Project class before fetching the project" do
    API::Project.stub!(:find)
    @client.project
    
    API::Project.site.should == 'http://localhost/api/v2/'
    API::Project.user.should == 'test'
    API::Project.password.should == 'test'
  end
  
  it "should set the appropriate attributes in the Project class before fetching projects" do    
    API::Project.stub!(:find)
    @client.projects
    
    API::Project.site.should == 'http://localhost/api/v2/'
    API::Project.user.should == 'test'
    API::Project.password.should == 'test'
  end
  
  it "should set the appropriate attributes in the User class before fetching the project" do
    API::User.stub!(:find)
    @client.user
    
    API::User.site.should == 'http://localhost/api/v2/'
    API::User.user.should == 'test'
    API::User.password.should == 'test'
  end
  
  it "should set the appropriate attributes in the User class before fetching projects" do    
    API::User.stub!(:find)
    @client.users
    
    API::User.site.should == 'http://localhost/api/v2/'
    API::User.user.should == 'test'
    API::User.password.should == 'test'
  end
  
  it "should be able to fetch the cards of a project" do  
    project = mock()
    project.should_receive(:cards)
    API::Project.stub!(:find).and_return(project)
    @client.cards
  end
end