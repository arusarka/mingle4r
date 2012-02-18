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
  
  context "find_without_pagination" do
    it "should be able to call active resource find method with proper params" do
      card_class = Card.send(:create_resource_class)
      card_class.should_receive(:find).with(:all, :params => {:page => 'all'})
      card_class.find_without_pagination(:all)
    end
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
      :id => 1237, :properties => [{:name => 'Story Status', :value => 'Completed',
        :type_description => 'Managed text list'}]})
    card.property_value('Story Status', 'In Development')
    card.property_value('Story Status').should == 'In Development'
  end
  
  context "card_type" do
    it "should be able to return the card type directly" do
      card = Card.new({:card_type_name => 'Story'})
      card.type.should == 'Story'
    end
    
    it "should return the card type set" do
      card = Card.new
      card.type = 'Defect'
      card.type.should == 'Defect'
    end
  end

  it "should be able to set the card type directly" do
    card = Card.new
    card.type = 'Story'
    card.card_type_name.should == 'Story'
  end
  
  context "for comments" do
    before(:each) do
      Card.site = 'http://localhost:9090/'
      Card.user = 'test'
      Card.password = 'test'
    end
    
    it "should be able to set the appropriate attributes in Comment class while fetching comments" do
      card =  Card.new({:number => 1})
      Comment.stub!(:find)
      card.comments    

      Comment.site.should == 'http://localhost:9090/cards/1'
      Comment.user.should == 'test'
      Comment.password.should == 'test'
    end

    it "should be able to add comments to a card" do
      comment = Comment.new(:content => 'test comment')
      Comment.stub!(:new).and_return(comment)
      comment.should_receive(:save)

      card =  Card.new({:number => 1})
      card.add_comment('test comment')
    end
    
    it "should set attributes for Comment class only once" do
      card =  Card.new({:number => 1})
      
      Comment.stub!(:find)
      Comment.should_receive(:site=).once
      Comment.should_receive(:user=).once
      Comment.should_receive(:password=).once
      
      card.comments
      card.comments
    end
  end

  context "murmurs" do
    before(:each) do
      Card.site = 'http://localhost:9090/'
      Card.user = 'test'
      Card.password = 'test'
    end

    it "should be able to set appropriate attributes for murmurs" do
      card =  Card.new({:number => 1})
      Murmur.stub!(:find)
      card.murmurs

      Murmur.site.should == 'http://localhost:9090/cards/1'
      Murmur.user.should == 'test'
      Murmur.password.should == 'test'
    end

    it "should set attributes for Comment class only once" do
      card =  Card.new({:number => 1})

      Murmur.stub!(:find)
      Murmur.should_receive(:site=).once
      Murmur.should_receive(:user=).once
      Murmur.should_receive(:password=).once

      card.murmurs
      card.murmurs
    end
  end
  
  context "exceuting transitions" do
    before(:each) do
      Card.site = 'http://localhost:9090/'
      Card.user = 'test'
      Card.password = 'test'
    end
    
    it "should be able to set the attributes in Transition class while fetching transitions" do
      card =  Card.new({:number => 1})
      Transition.stub!(:find)

      card.transitions                   
      Transition.site.should == 'http://localhost:9090/cards/1'
      Transition.user.should == 'test'
      Transition.password.should == 'test'
    end
    
    it "should set attributes for Transition class only once" do
      card =  Card.new({:number => 1})
      
      Transition.stub!(:find)
      Transition.should_receive(:site=).once
      Transition.should_receive(:user=).once
      Transition.should_receive(:password=).once
      
      card.transitions
      card.transitions
    end

    it "should be able to execute a transition" do    
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
  
  context "for attachments" do
    before(:each) do
      Card.site = 'http://localhost:9090/'
      Card.user = 'test'
      Card.password = 'test'
    end
    
    it "should set attributes for Attachment class only once" do
      card =  Card.new({:number => 1})
      
      Attachment.stub!(:find)
      Attachment.should_receive(:site=).once
      Attachment.should_receive(:user=).once
      Attachment.should_receive(:password=).once
      
      card.attachments
      card.attachments
    end
  end
  
  context "post setup hook" do
    it "should set the format of the class as card format" do
      format = Card.new.class.format
      format.should be_instance_of(Mingle4r::CardFormat)
    end
    
    it "should set the primary key as the id" do
      primary_key = Card.new.class.primary_key
      primary_key.should == 'number'
    end
  end
  
  context "encode" do
    it "should delegate to CardFormat properly" do
      card = Card.new(:name => 'some name', :number => 12)
      encoding_format = mock()
      encoding_format.should_receive(:encode).with(card.attributes, :root => 'card')
      
      card.class.format = encoding_format
      card.encode
    end
  end
end
