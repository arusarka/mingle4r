require File.dirname(__FILE__) + '/../../../spec_helper'

describe Mingle4r::API::V1::Wiki do
  it "should return the collection name properly" do
    Mingle4r::API::V1::Wiki.collection_name.should == 'wiki'
  end
  
  it "should return the element name properly" do
    Mingle4r::API::V1::Wiki.element_name.should == 'page'
  end
end