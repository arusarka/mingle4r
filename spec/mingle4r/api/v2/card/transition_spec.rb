require File.dirname(__FILE__) + '/../../../../spec_helper'

describe Mingle4r::API::V2::Card::Transition do
  before(:each) do
    Mingle4r::API::V2::Card::Transition.site     = 'http://localhost:8080/projects/test/cards/1/'
    Mingle4r::API::V2::Card::Transition.user     = 'testuser'
    Mingle4r::API::V2::Card::Transition.password = 'testuser'
  end
  
  it "should be able to execute a transition" do
    transition = Mingle4r::API::V2::Card::Transition.new('card' => 1,
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