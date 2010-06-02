require File.dirname(__FILE__) + '/spec_helper'

describe "Mingle4r" do
  it "should be able to create a module called Mingle4r" do
    lambda { Mingle4r }.should_not raise_error()
  end
end