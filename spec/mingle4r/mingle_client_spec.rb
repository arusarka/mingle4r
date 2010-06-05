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
  
  context "should delegate to project" do
    before(:each) do
      @project = mock()
      API::Project.stub!(:find).and_return(@project)
    end
    
    it "when fetching the cards of a project" do  
      @project.should_receive(:cards)
      @client.cards
    end

    it "when fetching a single card for a project" do
      @project.should_receive(:find_card).with(20)
      @client.find_card(20)
    end

    it "when filtering cards" do
      @project.should_receive(:filter_cards)
      @client.filter_cards('Type IS Story')
    end
    
    it "when creating a card" do
      @project.should_receive(:new_card)
      @client.new_card
    end
  end
  
end