require File.dirname(__FILE__) + '/spec_helper'

describe Mingle4r do
  it "should return my name" do
    Mingle4r::AUTHOR.should == 'Asur'
  end
end