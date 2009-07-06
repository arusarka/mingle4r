require File.dirname(__FILE__) + '/../spec_helper'

describe Mingle4r::Card do
  it "should be able to call active resource find method with proper params" do
    Mingle4r::Card.site = 'http://localhost/projects/test'
    Mingle4r::Card.user = 'user'
    Mingle4r::Card.password = 'password'
    
    card_class = Mingle4r::Card.send(:create_resource_class)
    card_class.should_receive(:find).with(:all, :params => {:page => 'all'})
    card_class.find_without_pagination(:all)
  end
  
  it "should set attributes in attachment class properly" do
    Mingle4r::Card.site = 'http://localhost/projects/test'
    Mingle4r::Card.user = 'user'
    Mingle4r::Card.password = 'password'
    
    card_obj = Mingle4r::Card.new
    card_obj.should_receive(:number).and_return(10)
    
    attachment_class_mock = mock(Class)
    Mingle4r::Card::Attachment.should_receive(:create_resource_class).any_number_of_times.and_return(attachment_class_mock)
    
    attachment_class_mock.should_receive(:find)
    card_obj.attachments
    
    Mingle4r::Card::Attachment.site.should == 'http://localhost/projects/test/cards/10'
    Mingle4r::Card::Attachment.user.should == 'user'
    Mingle4r::Card::Attachment.password.should == 'password'
  end
  
  it "should return the http body boundary" do
    Mingle4r::Card.site = 'http://localhost/projects/test'
    Mingle4r::Card.user = 'user'
    Mingle4r::Card.password = 'password'
    
    Mingle4r::Card.new.send(:boundary).should == '----------XnJLe9ZIbbGUYtzPQJ16u1'
  end
end
