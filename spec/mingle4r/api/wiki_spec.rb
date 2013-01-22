require File.dirname(__FILE__) + '/../../spec_helper'

include Mingle4r::API

describe Wiki do
  it "should set the collection name to 'wiki'" do
    Wiki.collection_name.should == 'wiki'
  end

  it "should element_name to 'page'" do
    Wiki.element_name.should == 'page'
  end

  it "should return the identifier as the id of the wiki" do
    Wiki.site = 'http://localhost'
    wiki = Wiki.new :identifier => 'some_wiki'
    wiki.id.should == 'some_wiki'
  end

  context "post setup hook" do
    it "should set the primary key as identifier" do
      Wiki.site = 'http://localhost'
      primary_key = Wiki.new.class.primary_key
      primary_key.should == 'identifier'
    end
  end

  context "for attachments" do
    before(:each) do
      Wiki.site = 'http://localhost:9090/'
      Wiki.user = 'test'
      Wiki.password = 'test'
    end

    it "should set attributes for Attachment class only once" do
      wiki = Wiki.new({:identifier => 'hello_world'})

      Attachment.stub!(:find)
      Attachment.should_receive(:site=).once
      Attachment.should_receive(:user=).once
      Attachment.should_receive(:password=).once

      wiki.attachments
      wiki.attachments
    end
  end
end
