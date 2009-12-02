require File.dirname(__FILE__) + '/../../../spec_helper'
require 'ostruct'

describe Mingle4r::API::V1::Card do
  it "should be able to call active resource find method with proper params" do
    Mingle4r::API::V1::Card.site = 'http://localhost/projects/test'
    Mingle4r::API::V1::Card.user = 'user'
    Mingle4r::API::V1::Card.password = 'password'
    
    card_class = Mingle4r::API::V1::Card.send(:create_resource_class)
    card_class.should_receive(:find).with(:all, :params => {:page => 'all'})
    card_class.find_without_pagination(:all)
  end
  
  it "should be able to get the value of a particular custom property for a card" do
    card = Mingle4r::API::V1::Card.new({:name => 'card1', :number => 1,
      :id => 1237, :cp_story_status => 'Completed'})
    Mingle4r::API::V1::PropertyDefinition.stub!(:column_name_for).and_return('cp_story_status')
    card.property_value('Story Status').should == 'Completed'
  end
  
  it "should be able to return the array of custom properties" do
    card = Mingle4r::API::V1::Card.new({:name => 'card1', :number => 1,
      :id => 1237, :cp_story_status => 'Completed', :cp_owner => 'Asur',
      :cp_planning_estimate => 3})
    Mingle4r::API::V1::PropertyDefinition.stub!(:find).and_return([OpenStruct.new({:name => 'Story Status', :column_name => 'cp_story_status'}),
      OpenStruct.new({:name => 'Owner', :column_name => 'cp_owner'}),
      OpenStruct.new({:name => 'Planning Estimate', :column_name => 'cp_planning_estimate'})])
    card.custom_properties.should == [{'Story Status' => 'Completed'}, {'Owner' => 'Asur'},
      {'Planning Estimate' => 3}]
  end
  
  it "should be able to set the value of a particular custom property for a card" do
    card =  Mingle4r::API::V1::Card.new({:name => 'card1', :number => 1,
      :id => 1237, :cp_story_status => 'Completed'})
    Mingle4r::API::V1::PropertyDefinition.stub!(:column_name_for).and_return('cp_story_status')
    card.property_value('Story Status', 'In Development')
    card.property_value('Story Status').should == 'In Development'
  end
  
  it "should set attributes in attachment class properly" do
    Mingle4r::API::V1::Card.site = 'http://localhost/projects/test'
    Mingle4r::API::V1::Card.user = 'user'
    Mingle4r::API::V1::Card.password = 'password'
    
    card_obj = Mingle4r::API::V1::Card.new
    card_obj.should_receive(:number).and_return(10)
    
    attachment_class_mock = mock(Class)
    Mingle4r::API::V1::Card::Attachment.should_receive(:create_resource_class).any_number_of_times.and_return(attachment_class_mock)
    
    attachment_class_mock.should_receive(:find)
    card_obj.attachments
    
    Mingle4r::API::V1::Card::Attachment.site.should == 'http://localhost/projects/test/cards/10'
    Mingle4r::API::V1::Card::Attachment.user.should == 'user'
    Mingle4r::API::V1::Card::Attachment.password.should == 'password'
  end
  
  it "should return the http body boundary" do
    Mingle4r::API::V1::Card.site = 'http://localhost/projects/test'
    Mingle4r::API::V1::Card.user = 'user'
    Mingle4r::API::V1::Card.password = 'password'
    
    Mingle4r::API::V1::Card.new.send(:boundary).should == '----------XnJLe9ZIbbGUYtzPQJ16u1'
  end
end
