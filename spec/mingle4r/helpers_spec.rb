require File.dirname(__FILE__) + '/../spec_helper'

describe Mingle4r::Helpers do
  it "should return a token" do
    Mingle4r::Helpers.fast_token.should_not be_nil
  end
  
  it "should not return the same token" do
    token1 = Mingle4r::Helpers.fast_token
    token2 = Mingle4r::Helpers.fast_token
    token1.should_not equal(token2)
  end
  
  it "should return a string in proper html format" do
    string = 'Hello(whosoever) world []'
    html_result = Mingle4r::Helpers.encode2html(string)
    html_expected = 'Hello%28whosoever%29%20world%20%5B%5D'
    html_result.should == html_expected
  end
end
