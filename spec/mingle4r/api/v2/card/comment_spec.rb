require File.dirname(__FILE__) + '/../../../../spec_helper'

describe Mingle4r::API::V2::Card::Comment do
  it "should set the element_name to comment" do
    Mingle4r::API::V2::Card::Comment.site     = 'http://localhost:9090/api/v2/projects/cards/1'
    Mingle4r::API::V2::Card::Comment.user     = 'testuser'
    Mingle4r::API::V2::Card::Comment.password = 'testuser'
    comment = Mingle4r::API::V2::Card::Comment.new
    comment.class.element_name.should == 'comment'
  end
  
  it "should set the collection_name to comments" do
    Mingle4r::API::V2::Card::Comment.site     = 'http://localhost:9090/api/v2/projects/cards/1'
    Mingle4r::API::V2::Card::Comment.user     = 'testuser'
    Mingle4r::API::V2::Card::Comment.password = 'testuser'
    comment = Mingle4r::API::V2::Card::Comment.new
    comment.class.collection_name.should == 'comments'
  end
  
  it "should be able to return the comment text as the to_s method" do 
    Mingle4r::API::V2::Card::Comment.site     = 'http://localhost:9090/api/v2/projects/cards/1'
    Mingle4r::API::V2::Card::Comment.user     = 'testuser'
    Mingle4r::API::V2::Card::Comment.password = 'testuser'
    comment = Mingle4r::API::V2::Card::Comment.new(:content => 'test comment')
    comment.to_s.should == 'test comment'
  end
end
