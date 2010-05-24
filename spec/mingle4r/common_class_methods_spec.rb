require File.dirname(__FILE__) + '/../spec_helper'

class DummyClass
  module InstanceMethods
  end
  
  # module ClassMethods
  # end
  extend Mingle4r::CommonClassMethods
end

describe DummyClass do
  it "should be able to set the site properly" do
    url = 'http://localhost/test'
    DummyClass.site = url
    DummyClass.site.should == url
  end
  
  it "should be able to set the user properly" do
    user = 'testuser'
    DummyClass.user = user
    DummyClass.user.should == user
  end
  
  it "should be able to set the password properly" do
    password = 'password'
    DummyClass.password = password
    DummyClass.password.should == password
  end
  
  xit "should understand that the attributes have been set" do
    DummyClass.site = 'http://localhost:8080'
    DummyClass.user = 'test'
    DummyClass.password = 'password'
    assert DummyClass.all_attributes_set?
  end
  
  it "should be able to create an instance" do
    dummy_obj = DummyClass.new
    dummy_obj.should_not == nil
  end
  
  it "should be able to create a class inherited from ActiveResource::Base" do
    dummy_obj = DummyClass.new
    dummy_obj.class.superclass.should == ActiveResource::Base
  end
  
  context "resoure class" do
    before(:each) do
      site = 'http://localhost/foo'
      DummyClass.site = site
      DummyClass.user = 'test'
      DummyClass.password = 'password'
    end
    
    it "is same when site is not changed" do
      class1 = DummyClass.new.class
      DummyClass.site = 'http://localhost/foo'
      class2 = DummyClass.new.class
      class1.should == class2
    end

    it "is different when site is changed" do
      site2 = 'http://localhost/bar'
      class1 = DummyClass.new.class
      DummyClass.site = site2
      class2 = DummyClass.new.class
      class1.should_not == class2
    end
  end
    
  context "method_missing" do
    before do
      class FooBar
        extend Mingle4r::CommonClassMethods
      end
    end
    
    it "should check if resource class has been set before calling the resource class's method" do
      lambda{FooBar.foo_bar}.should(raise_error(Mingle4r::ResourceNotSetup) do |err|
        err.message.should == 'Site not set for FooBar.'
      end)
    end
  end
end