require 'spec_helper'

describe "MingleResource" do
  it "should be equal to ActiveResource::Base" do
    MingleResource.should == ActiveResource::Base
  end
end