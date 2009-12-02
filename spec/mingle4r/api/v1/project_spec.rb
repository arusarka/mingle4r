require File.dirname(__FILE__) + '/../../../spec_helper'
require 'ostruct'

describe Mingle4r::API::V1::Project do
  it "should return the set the Card class attributes properly" do
    Mingle4r::API::V1::Project.site = 'http://localhost'
    Mingle4r::API::V1::Project.user = 'test'
    Mingle4r::API::V1::Project.password = 'password'
    
    proj = Mingle4r::API::V1::Project.new(:identifier => 'test')
    card_class_mock = mock(Class)
    Mingle4r::API::V1::Card.should_receive(:create_resource_class).any_number_of_times.and_return(card_class_mock)
    card_class_mock.should_receive(:find_without_pagination).with(:all)
    
    class Mingle4r::API
      class << self
        def new(*args)
          # OpenStruct.new({:card_class => Mingle4r::Card})
        end
      end
    end
    
    proj.cards
    
    Mingle4r::API::V1::Card.site.should == 'http://localhost/projects/test'
    Mingle4r::API::V1::Card.user.should == 'test'
    Mingle4r::API::V1::Card.password.should == 'password'
  end
end