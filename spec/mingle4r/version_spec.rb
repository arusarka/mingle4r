require File.dirname(__FILE__) + '/../spec_helper'
require 'rubygems/specification'

describe "Mingle4r::Version" do
  it "should return proper version" do
    Mingle4r::Version::to_s.should == '0.4.5'
  end
  
  it "should have the same version as in the gemspec" do
    gemspec_data = File.read(File.dirname(__FILE__) + '/../../mingle4r.gemspec')
    gemspec_version = eval(gemspec_data).version.to_s
    Mingle4r::Version::to_s.should == gemspec_version
  end
end