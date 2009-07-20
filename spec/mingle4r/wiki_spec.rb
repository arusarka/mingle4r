require File.dirname(__FILE__) + '/../spec_helper'

describe Mingle4r::Wiki do
  it "should return the collection name properly" do
    Mingle4r::Wiki::collection_name.should == 'wiki'
  end
  
  it "should return the element name properly" do
    Mingle4r::Wiki::element_name.should == 'page'
  end
end