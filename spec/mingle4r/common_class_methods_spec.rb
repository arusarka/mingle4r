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
  
  it "should understand that the attributes have been set" do
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
  
  it "should create different classes when site is changed" do
    site1 = 'http://localhost/foo'
    site2 = 'http://localhost/bar'
    DummyClass.site = site1
    class1 = DummyClass.send(:create_resource_class)
    DummyClass.site = site2
    class2 = DummyClass.send(:create_resource_class)
    class1.should_not == class2
  end
  
  it "should be able to find the instance methods module in the class" do
    DummyClass.send(:instance_methods_module_name).should == 'InstanceMethods'
  end
  
  it "should not be able to find class methods module in the class" do
    DummyClass.send(:class_methods_module_name).should be_nil
  end
  
  it "should return the class name only without nesting of namespaces" do
    DummyClass.send(:class_name).should == 'DummyClass'
  end
  
  it "should call find with proper params" do
    # open access to @resource var
    class << DummyClass
      attr_writer :resource_class
    end
    
    mock_class = mock(Class)
    DummyClass.resource_class = mock_class
    mock_class.should_receive(:find).with(:all, :from => 'http://localhost/test', :params => {:foo => 'bar'})
    DummyClass.find(:all, :from => 'http://localhost/test', :params => {:foo => 'bar'})
  end
end