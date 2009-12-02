require File.dirname(__FILE__) + '/../spec_helper'

describe Mingle4r::API do
  it "should be able to determne the version of mingle" do
    Mingle4r::API.stub!(:mingle_about_page).and_return(mingle_html_2)
    Mingle4r::API.mingle_version.should == 2.3
  end
  
  it "should be able to create a Mingle4r::API::V1 object for mingle 2 instance" do
    Mingle4r::API.stub!(:mingle_about_page).and_return(mingle_html_2)
    api = Mingle4r::API.create('http://localhost:9090')
    api.should be_instance_of(Mingle4r::API::V1)
  end
end