require File.dirname(__FILE__) + '/spec_helper'

describe Mingle4r do
  xit "should return my name" do
    Mingle4r::AUTHOR.should == 'Asur'
  end
  
  it "should return proper version" do
    Mingle4r::Version::to_s.should == '0.2.5'
  end
end