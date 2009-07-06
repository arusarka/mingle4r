require File.dirname(__FILE__) + '/../spec_helper'

describe Mingle4r::Project do
  it "should return the set the Card class attributes properly" do
    Mingle4r::Project.site = 'http://localhost'
    Mingle4r::Project.user = 'test'
    Mingle4r::Project.password = 'password'
    
    proj = Mingle4r::Project.new(:identifier => 'test')
    card_class_mock = mock(Class)
    Mingle4r::Card.should_receive(:create_resource_class).any_number_of_times.and_return(card_class_mock)
    card_class_mock.should_receive(:find_without_pagination).with(:all)
    
    proj.cards
    
    Mingle4r::Card.site.should == 'http://localhost/projects/test'
    Mingle4r::Card.user.should == 'test'
    Mingle4r::Card.password.should == 'password'
  end
end