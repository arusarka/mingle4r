require File.dirname(__FILE__) + '/../../spec_helper'

include Mingle4r::API

describe ExecuteMql do
  it "should be able to call find with appropriate parameters when an MQL query is made" do
    ExecuteMql.site = 'http://localhost/projects/dummy/cards'
    ExecuteMql.user = 'test'
    ExecuteMql.password = 'test'
    
    query = 'SELECT "Accepted in Iteration" WHERE type = Story'
    mql_class = ExecuteMql.instance_variable_get('@resource_class')
    mql_class.should_receive(:find).with(:all, :params => {:mql => query})
    ExecuteMql.query(query)
  end
  
  it "should set the collection name to execute_mql" do
    ExecuteMql.collection_name.should == 'execute_mql'
  end
  
  it "should set the element name to 'result'" do
    ExecuteMql.element_name.should == 'result'
  end
end