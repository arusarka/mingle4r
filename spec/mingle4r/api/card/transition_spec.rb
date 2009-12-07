require File.dirname(__FILE__) + '/../../../spec_helper'

include Mingle4r::API

describe Transition do
  before(:each) do
    Transition.site     = 'http://localhost:8080/projects/test/cards/1/'
    Transition.user     = 'testuser'
    Transition.password = 'testuser'
  end
  
  it "should be able to execute a transition" do
    transition = Transition.new('card' => 1,
    'transition_execution_url' => 'http://localhost:8080/projects/test/transition_executions/2.xml')
    
    trans_exec_xml = {'card' => 1}.to_xml(:root => 'transition_execution',
    :dasherize => false)
    mock_connection = mock()
    transition.class.stub!(:connection).and_return(mock_connection)
    mock_connection.should_receive(:post).with('/projects/test/transition_executions/2.xml', trans_exec_xml,
    transition.class.headers)
    transition.execute
  end
end