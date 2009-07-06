require File.dirname(__FILE__) + '/spec_helper'

describe Mingle4r do
  it "should return my name" do
    Mingle4r::AUTHOR.should == 'Asur'
  end
  
  it "should return proper version" do
    Mingle4r::VERSION.should == '0.0.1'
  end
end