require File.dirname(__FILE__) + '/../../spec_helper'

include Mingle4r::API

describe Wiki do
  it "should set the collection name to 'wiki'" do
    Wiki.collection_name.should == 'wiki'
  end
  
  it "should element_name to 'page'" do
    Wiki.element_name.should == 'page'
  end
end