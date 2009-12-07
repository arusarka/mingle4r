require File.dirname(__FILE__) + '/../../spec_helper'

include Mingle4r::API

describe Card do
  before(:each) do
    Card.site = 'http://localhost/projects/test'
    Card.user = 'user'
    Card.password = 'password'
  end
  
  it "should have a collection name of 'cards" do
    Card.collection_name.should == 'cards'
  end
  
  it "should have an element name of 'card" do
    Card.element_name.should == 'card'
  end
  
  it "should be able to call active resource find method with proper params" do
    card_class = Card.send(:create_resource_class)
    card_class.should_receive(:find).with(:all, :params => {:page => 'all'})
    card_class.find_without_pagination(:all)
  end
  
  it "should be able to give the number as the id of the card" do
    card = Card.new({:name => 'card1', :number => 1, :id => 1237})
    card.id.should == 1
  end
  
  it "should be able to get the value of a particular custom property for a card" do
    card = Card.new({:name => 'card1', :number => 1,
      :id => 1237, :properties => [{:name => 'Story Status', :value => 'Completed'}]})
    card.property_value('Story Status').should == 'Completed'
  end
  
  it "should be able to return the array of custom properties" do
    card = Card.new({:name => 'card1', :number => 1,
      :id => 1237, :properties => [{:name => 'Story Status', :value => 'Completed'},
        {:name => 'Owner', :value => 'Asur'}, {:name => 'Planning Estimate', :value => 3}]})
    card.custom_properties.should == [{'Story Status' => 'Completed'}, {'Owner' => 'Asur'},
      {'Planning Estimate' => 3}]
  end
  
  it "should be able to set the value of a particular custom property for a card" do
    card =  Card.new({:name => 'card1', :number => 1,
      :id => 1237, :properties => [{:name => 'Story Status', :value => 'Completed'}]})
    card.property_value('Story Status', 'In Development')
    card.property_value('Story Status').should == 'In Development'
  end
  
  describe "for comments" do
    it "should be able to set the appropriate attributes in Comment class while fetching comments" do
      Card.site = 'http://localhost:9090/'
      Card.user = 'test'
      Card.password = 'test'

      card =  Card.new({:number => 1})
      Comment.stub!(:find)
      card.comments    

      Comment.site.should == 'http://localhost:9090/cards/1'
      Comment.user.should == 'test'
      Comment.password.should == 'test'
    end

    it "should be able to add comments to a card" do
      Card.site = 'http://localhost:9090/'
      Card.user = 'test'
      Card.password = 'test'

      comment = Comment.new(:content => 'test comment')
      Comment.stub!(:new).and_return(comment)
      comment.should_receive(:save)

      card =  Card.new({:number => 1})
      card.add_comment('test comment')
    end
  end

  it "should be able to set the attributes in Transition class while fetching transitions" do
    Card.site = 'http://localhost:9090/'
    Card.user = 'test'
    Card.password = 'test'
    
    card =  Card.new({:number => 1})
    Transition.stub!(:find)
                                       
    card.transitions                   
    Transition.site.should == 'http://localhost:9090/cards/1'
    Transition.user.should == 'test'
    Transition.password.should == 'test'
  end
  
  it "should be able to execute a transition" do    
    Card.site = 'http://localhost:9090/'
    Card.user = 'test'
    Card.password = 'test'
    
    Transition.site = 'http://localhost:9090/cards/1'
    Transition.user = 'testuser'
    Transition.password = 'testuser'
    
    card = Card.new(:number => 1)
    transition1 = Transition.new(:name => 'Dummy transition')
    transition2 = Transition.new(:name => 'Accepted')
    transitions = [transition1, transition2]
    Transition.stub!(:find).and_return(transitions)
    args = {:name => 'Accepted', :comment => 'Test comment'}
    transition2.should_receive(:execute).with(args)
    
    card.execute_transition(args)
  end
end