require File.dirname(__FILE__) + '/../../../spec_helper'

describe Mingle4r::API::V1::TransitionExecution do
  it "should be able execute a transition given appropriate parameters" do
    Mingle4r::API::V1::TransitionExecution.site = 'http://localhost:8080/projects/test'
    Mingle4r::API::V1::TransitionExecution.user = 'testuser'
    Mingle4r::API::V1::TransitionExecution.password = 'testuser'
    
    conn_mock = mock()
    conn_mock.should_receive(:post)
    
    transition_execution = Mingle4r::API::V1::TransitionExecution.new(:name => 'Ready for showcase',
    :card => 1)
    transition_execution.class.stub!(:connection).and_return(conn_mock)
    
    transition_execution.execute
  end
end