require File.dirname(__FILE__) + '/../../../../spec_helper'

describe Mingle4r::API::V1::Card::Attachment do
  it "should be able to create a class inherited from ActiveResource::Base" do
    attachment_class = mock(Object)
    
    attachment_class.should_receive(:site=).any_number_of_times
    attachment_class.should_receive(:user=).any_number_of_times
    attachment_class.should_receive(:password=).any_number_of_times
    attachment_class.should_receive(:collection_name=).any_number_of_times
    attachment_class.should_receive(:element_name=).any_number_of_times
    attachment_class.should_receive(:include).any_number_of_times
    Class.should_receive(:new).with(MingleResource).any_number_of_times.and_return(attachment_class)
    
    Mingle4r::API::V1::Card::Attachment.site = ''
    Mingle4r::API::V1::Card::Attachment.user = ''
    Mingle4r::API::V1::Card::Attachment.password = ''
    
    Mingle4r::API::V1::Card::Attachment.send(:create_resource_class).should == attachment_class
  end
  
  it "should be able to download file to a location" do
    Mingle4r::API::V1::Card::Attachment.site = 'http://localhost/test'
    Mingle4r::API::V1::Card::Attachment.user = 'test'
    Mingle4r::API::V1::Card::Attachment.password = 'password'
    
    attachment_obj = Mingle4r::API::V1::Card::Attachment.new
    attachment_obj.should_receive(:url).and_return('/attachment')
    attachment_obj.should_receive(:file_name).and_return('attach')
    
    request_obj = mock(Object)
    request_obj.should_receive(:basic_auth)
    
    response_obj = mock(Object)
    response_obj.should_receive(:body).and_return('test text')
    
    Net::HTTP::Get.should_receive(:new).and_return(request_obj)
    Net::HTTP.should_receive(:start).and_return(response_obj)
    
    
    attachment_obj.download()
    
    File.exist?('attach').should == true
    file_contents = IO.read('attach')
    file_contents.should == 'test text'
    File.delete('attach')
  end
end