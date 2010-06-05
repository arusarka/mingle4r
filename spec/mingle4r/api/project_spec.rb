require File.dirname(__FILE__) + '/../../spec_helper'

include Mingle4r::API

describe Project do
  def card_with_number(number)
    Card.site = 'http://localhost'
    Card.user = 'test'
    Card.password = 'test'
    Card.new :number => number
  end
  
  before do
    Project.site     = 'http://localhost/api/v2/'
    Project.user     = 'test'
    Project.password = 'test'
    @project = Project.new(:identifier => 'some-id')
  end
  
  context "fetching cards" do
    it "should be able to ask for a single card" do
      Card.should_receive(:find).with(42)
      @project.find_card(42)
    end
  end

  context "when filtering cards" do
    it "should delegate to Card" do
      Card.should_receive(:apply_filter).with('Type IS Story')
      @project.filter_cards('Type IS Story')
    end
  end
  
  context "when creating new card obejct" do
    it "should set the card attributes" do
      base_site = 'http://enterprise-server/mingle/api/v2/'
      Project.site = base_site
      Project.user = 'someone'
      Project.password = 'very-secret'
      project = Project.new(:identifier => 'foobar')
      project.new_card
      
      Card.site.should == File.join(base_site, 'projects', project.identifier)
      Card.user.should == 'someone'
      Card.password.should == 'very-secret'
    end
    
    it "should instantiate a card object" do
      card_obj = mock('Card')
      Card.should_receive(:new).and_return(card_obj)
      @project.new_card.should == card_obj
    end
  end
  
  context "post setup" do
    it "should set identifier ias the primary key" do
      primary_key = Project.new.class.primary_key
      primary_key.should == 'identifier'
    end
  end
end
