require File.dirname(__FILE__) + '/../../spec_helper'

include Mingle4r::API

describe Project do
  before do
    Project.site     = 'http://localhost/api/v2/'
    Project.user     = 'test'
    Project.password = 'test'
  end
  
  context "fetching users" do
    it "should set the attributes for User class only once" do
      project = Project.new(:identifier => 'some-id')
      
      User.stub!(:find)
      User.should_receive(:site=).once
      User.should_receive(:user=).once
      User.should_receive(:password=).once
      
      project.users
      project.users
    end
  end

  context "fetching cards" do
    it "should set the attributes for Card class only once" do
      project = Project.new(:identifier => 'some-id')
      
      Card.stub!(:find_without_pagination)
      Card.should_receive(:site=).once
      Card.should_receive(:user=).once
      Card.should_receive(:password=).once
      
      project.cards
      project.cards
    end
  end
  
  context "fetching wikis" do
    it "should set the attributes for Wiki class only once" do
      project = Project.new(:identifier => 'some-id')
      
      Wiki.stub!(:find)
      Wiki.should_receive(:site=).once
      Wiki.should_receive(:user=).once
      Wiki.should_receive(:password=).once
      
      project.wikis
      project.wikis
    end
  end
end
