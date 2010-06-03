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
  
  context "fetching users" do
    it "should set the attributes for User class only once" do
      User.stub!(:find)
      User.should_receive(:site=).once
      User.should_receive(:user=).once
      User.should_receive(:password=).once
      
      @project.users
      @project.users
    end
  end

  context "fetching cards" do
    it "should set the attributes for Card class only once" do
      Card.stub!(:find_without_pagination)
      Card.should_receive(:site=).once
      Card.should_receive(:user=).once
      Card.should_receive(:password=).once
      
      @project.cards
      @project.cards
    end
    
    it "should be able to ask for a single card" do
      Card.should_receive(:find).with(42)
      @project.find_card(42)
    end
  end

  context "when filtering cards" do
    it "should execute the right mql" do
      ExecuteMql.should_receive(:query).with('SELECT Number WHERE Type IS Story').
      and_return([{'number' => 12}])
      Card.stub!(:find_without_pagination).and_return([])  
      @project.filter_cards('Type IS Story')
    end

    it "should filter the cards matching the filter" do
      ExecuteMql.stub!(:query).and_return([{'number' => '12'}, {'number' => '13'}])
        card_1 = card_with_number 12
        card_2 = card_with_number 13
        card_3 = card_with_number 21
        Card.stub!(:find_without_pagination).and_return([card_1, card_2, card_3])
        cards = @project.filter_cards('Type IS Defect')
        cards.should include card_1, card_2
        cards.should_not include card_3
      end
    end
  
  context "fetching wikis" do
    it "should set the attributes for Wiki class only once" do
      Wiki.stub!(:find)
      Wiki.should_receive(:site=).once
      Wiki.should_receive(:user=).once
      Wiki.should_receive(:password=).once
      
      @project.wikis
      @project.wikis
    end
  end
  
  context "fetching property definitions" do
    it "should set the attributes for PropertyDefinition class only once" do
      PropertyDefinition.stub!(:find)
      PropertyDefinition.should_receive(:site=).once
      PropertyDefinition.should_receive(:user=).once
      PropertyDefinition.should_receive(:password=).once
      
      @project.property_definitions
      @project.property_definitions
    end
  end
  
  context "murmurs" do
    def any_murmur
      OpenStruct.new(:save => 'do nothing')
    end
    
    it "should set the attributes for Murmur class only once when fetching" do
      Murmur.stub!(:find)
      Murmur.should_receive(:site=).once
      Murmur.should_receive(:user=).once
      Murmur.should_receive(:password=).once
      
      @project.murmurs
      @project.murmurs
    end
    
    it "should set the attributes for Murmur class only once when posting" do
      Murmur.stub!(:new).and_return(any_murmur)
      Murmur.should_receive(:site=).once
      Murmur.should_receive(:user=).once
      Murmur.should_receive(:password=).once
      
      @project.post_murmur('hello')
      @project.post_murmur('world')
    end
  end
  
  context "executing an mql" do
    it "should set the attributes of the ExecuteMql class only once" do
      ExecuteMql.stub!(:query)
      ExecuteMql.should_receive(:site=).once
      ExecuteMql.should_receive(:user=).once
      ExecuteMql.should_receive(:password=).once
      
      @project.execute_mql('Select name WHERE type is Story')
      @project.execute_mql('Select name WHERE type is Defect')
    end
  end
  
  context "post setup" do
    it "should set identifier ias the primary key" do
      primary_key = Project.new.class.primary_key
      primary_key.should == 'identifier'
    end
  end
end
