require File.dirname(__FILE__) + '/../spec_helper'
require 'ostruct'

describe Mingle4r::PropertyDefinition do
  before(:all) do
    Mingle4r::PropertyDefinition.site = 'http://localhost:8080/projects/test'
    Mingle4r::PropertyDefinition.user = 'test'
    Mingle4r::PropertyDefinition.password = 'secret'
  end
  
  it "should return the element name properly" do
    Mingle4r::PropertyDefinition::element_name.should == 'record'
  end
  
  it "should return the property value" do
    class Mingle4r::PropertyDefinition
      class << self
        attr_accessor :resource_class
      end
    end
    resource_class = mock(Class)
    property_1 = { :name => 'Test Property', :column_name => 'test_property_name' }
    property_2 = { :name => 'Added in Iteration number', :column_name => 'added_in_iteration_number'}
    find_results = [OpenStruct.new(property_1), OpenStruct.new(property_2)]
    Mingle4r::PropertyDefinition.resource_class = resource_class
    resource_class.should_receive(:find).with(:all).any_number_of_times.and_return(find_results)
    Mingle4r::PropertyDefinition.column_name_for('Test Property').should == 'test_property_name'
    Mingle4r::PropertyDefinition.column_name_for('Added in Iteration number').should == 'added_in_iteration_number'
  end
end