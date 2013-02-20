require File.dirname(__FILE__) + '/spec_helper'
require 'rubygems/specification'

describe "Mingle4r::Version" do
  def version_in_VERSION_file
    version_file_path = File.dirname(__FILE__) + '/../VERSION'
    IO.read(version_file_path).chomp
  end
  
  def gemspec_version
    gemspec_data = File.read(File.dirname(__FILE__) + '/../mingle4r.gemspec')
    eval(gemspec_data).version.to_s
  end

  it "should return proper version" do
    version_in_VERSION_file.should == '0.5.1'
  end
  
  it "should have the same version as in the gemspec" do
    version_in_VERSION_file.should == gemspec_version
  end
end
