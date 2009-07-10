require File.dirname(__FILE__) + '/../spec_helper'

describe Mingle4r::Helpers do
  it "should return a token" do
    assert Mingle4r::Helpers::fast_token
  end
  
  it "should not return the same token" do
    token1 = Mingle4r::Helpers::fast_token
    token2 = Mingle4r::Helpers::fast_token
    assert_not_equal(token1, token2)
  end
end