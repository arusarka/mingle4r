require File.dirname(__FILE__) + '/../../../spec_helper'

describe Mingle4r::API::V2::Card do
  before(:each) do
    Mingle4r::API::V2::Card.site = 'http://localhost/projects/test'
    Mingle4r::API::V2::Card.user = 'user'
    Mingle4r::API::V2::Card.password = 'password'
  end
  
  it "should have a collection name of 'cards" do
    Mingle4r::API::V2::Card.collection_name.should == 'cards'
  end
  
  it "should have an element name of 'card" do
    Mingle4r::API::V2::Card.element_name.should == 'card'
  end
  
  it "should be able to call active resource find method with proper params" do
    card_class = Mingle4r::API::V2::Card.send(:create_resource_class)
    card_class.should_receive(:find).with(:all, :params => {:page => 'all'})
    card_class.find_without_pagination(:all)
  end
  
  it "should be able to give the number as the id of the card" do
    card = Mingle4r::API::V2::Card.new({:name => 'card1', :number => 1, :id => 1237})
    card.id.should == 1
  end
  
  it "should be able to get the value of a particular custom property for a card" do
    card = Mingle4r::API::V2::Card.new({:name => 'card1', :number => 1,
      :id => 1237, :properties => [{:name => 'Story Status', :value => 'Completed'}]})
    card.property_value('Story Status').should == 'Completed'
  end
  
  it "should be able to return the array of custom properties" do
    card = Mingle4r::API::V2::Card.new({:name => 'card1', :number => 1,
      :id => 1237, :properties => [{:name => 'Story Status', :value => 'Completed'},
        {:name => 'Owner', :value => 'Asur'}, {:name => 'Planning Estimate', :value => 3}]})
    card.custom_properties.should == [{'Story Status' => 'Completed'}, {'Owner' => 'Asur'},
      {'Planning Estimate' => 3}]
  end
  
  it "should be able to set the value of a particular custom property for a card" do
    card =  Mingle4r::API::V2::Card.new({:name => 'card1', :number => 1,
      :id => 1237, :properties => [{:name => 'Story Status', :value => 'Completed'}]})
    card.property_value('Story Status', 'In Development')
    card.property_value('Story Status').should == 'In Development'
  end
  
  describe "for comments" do
    it "should be able to set the appropriate attributes in V2::Comment class while fetching comments" do
      Mingle4r::API::V2::Card.site = 'http://localhost:9090/'
      Mingle4r::API::V2::Card.user = 'test'
      Mingle4r::API::V2::Card.password = 'test'

      card =  Mingle4r::API::V2::Card.new({:number => 1})
      Mingle4r::API::V2::Card::Comment.stub!(:find)
      card.comments    

      Mingle4r::API::V2::Card::Comment.site.should == 'http://localhost:9090/cards/1'
      Mingle4r::API::V2::Card::Comment.user.should == 'test'
      Mingle4r::API::V2::Card::Comment.password.should == 'test'
    end

    it "should be able to add comments to a card" do
      Mingle4r::API::V2::Card.site = 'http://localhost:9090/'
      Mingle4r::API::V2::Card.user = 'test'
      Mingle4r::API::V2::Card.password = 'test'

      comment = Mingle4r::API::V2::Card::Comment.new(:content => 'test comment')
      Mingle4r::API::V2::Card::Comment.stub!(:new).and_return(comment)
      comment.should_receive(:save)

      card =  Mingle4r::API::V2::Card.new({:number => 1})
      card.add_comment('test comment')
    end
  end
end