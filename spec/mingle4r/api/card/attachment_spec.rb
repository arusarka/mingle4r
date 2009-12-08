require File.dirname(__FILE__) + '/../../../spec_helper'

include Mingle4r::API

describe Attachment do
  before(:each) do
    Attachment.site     = 'http://localhost'
    Attachment.user     = 'test'
    Attachment.password = 'test'
  end
  
  it "should be able to give the file_name as id" do
    attachment = Attachment.new(:file_name => 'screen-shot.jpg')
    attachment.id.should == 'screen-shot.jpg'
  end
  
  it "should be able to return the file_name as the name of the attachment" do
    attachment = Attachment.new(:file_name => 'screen-shot.jpg')
    attachment.name.should == 'screen-shot.jpg'
  end
end