require File.dirname(__FILE__) + '/../../../spec_helper'

include Mingle4r::API

describe Comment do
  it "should set the element_name to comment" do
    Comment.site     = 'http://localhost:9090/api/v2/projects/cards/1'
    Comment.user     = 'testuser'
    Comment.password = 'testuser'
    comment = Comment.new
    comment.class.element_name.should == 'comment'
  end

  it "should set the collection_name to comments" do
    Comment.site     = 'http://localhost:9090/api/v2/projects/cards/1'
    Comment.user     = 'testuser'
    Comment.password = 'testuser'
    comment = Comment.new
    comment.class.collection_name.should == 'comments'
  end

  it "should be able to return the comment text as the to_s method" do 
    Comment.site     = 'http://localhost:9090/api/v2/projects/cards/1'
    Comment.user     = 'testuser'
    Comment.password = 'testuser'
    comment = Comment.new(:content => 'test comment')
    comment.to_s.should == 'test comment'
  end
end
