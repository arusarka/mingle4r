require File.dirname(__FILE__) + '/../spec_helper'

include Mingle4r

class DummyCard < ActiveResource::Base
  def to_xml(options = {})
    self.class.format.encode(attributes, options)
  end
end

class CardType < ActiveResource::Base ; end

describe CardFormat do
  before(:all) do
    DummyCard.site = 'http://localhost'
    CardType.site = 'http://localhost'
  end
  
  before(:each) do
    @card_format = CardFormat.new
  end

  it "should be have the extension as 'xml'" do
    @card_format.extension.should == 'xml'
  end

  it "should have a mime type of application/xml" do
    @card_format.mime_type.should == 'application/xml'
  end

  context "decode" do
    it "should decode to right xml" do
      xml = <<-XML
      <?xml version="1.0" encoding="UTF-8"?>
      <cards type="array">
        <card><name>Yet another bug</name>
          <card_type><name>Bug</name></card_type>
          <properties type="array">
            <property type_description="Card" hidden="false">
              <name>Defect Fix Completed in Iteration</name>
              <value url="http://localhost:8080/api/v2/projects/agile_hybrid_project/cards/34.xml">
                <number type="integer">34</number>
              </value>
            </property>
          </properties>
        </card>
      </cards>
XML
      @card_format.decode(xml).should == [{"name"=>"Yet another bug", "card_type_name"=>"Bug",
        "properties"=>[{"name"=>"Defect Fix Completed in Iteration", "type_description"=>"Card", "value"=>34, 
          "hidden"=>"false"}]}]
    end
    
    it "should be able to decode tree relatioship property appropriately" do
      xml = load_fixture('card_with_tree_relationship_property_raw.xml')
      expected = [{"number"=>119, "name"=>"Contact API", "card_type_name"=>"Story",
      "properties"=>[{"name"=>"Feature", "type_description"=>"Any card used in tree",
        "value"=> 87, "hidden"=>"false"}]}]
      actual = @card_format.decode(xml)
      actual.should == expected
    end
    
    it "should be able to decode link to other card property appropriately" do
      xml = load_fixture('card_with_card_relationship_property_raw.xml')
      expected = [{"number"=>119, "name"=>"Contact API", "card_type_name"=>"Story",
      "properties" =>[{"name"=>"Accepted in Iteration", "type_description"=>"Card",
        "value" => nil, "hidden"=>"false"}, {"name"=>"Added to Scope in Iteration",
          "type_description"=>"Card", "value" => 37, "hidden"=>"false"}]}]
      actual = @card_format.decode(xml)
      actual.should == expected
    end

    it "should be able to decode card_type appropriately" do
      xml = load_fixture('card_with_card_relationship_property_raw.xml')
      expected = [{"number"=>119, "name"=>"Contact API", "card_type_name"=>"Story",
      "properties" =>[{"name"=>"Accepted in Iteration", "type_description"=>"Card",
        "value" => nil, "hidden"=>"false"}, {"name"=>"Added to Scope in Iteration",
          "type_description"=>"Card", "value" => 37, "hidden"=>"false"}]}]
      actual = @card_format.decode(xml)
      actual.should == expected
    end

    it "should be able to decode user properties appropriately" do
      xml = load_fixture('card_with_team_member_property_raw.xml')
      expected = [{"number"=>119, "name"=>"Contact API", "card_type_name"=>"Story",
      "properties" =>[{"name"=>"Owner", "type_description"=>"Automatically generated from the team list",
        "value" => 910, "hidden"=>"false"}]}]
      actual = @card_format.decode(xml)
      actual.should == expected
    end
  end

  context "encode" do
    it "should be able to dasherize the tags properly" do
      xml = '<?xml version="1.0" encoding="UTF-8"?>' + "\n" +
      "<dummy_card>\n" +
      "  <card_type>\n" +
      "  </card_type>\n" +
      "</dummy_card>\n"
      DummyCard.format = @card_format
      dummy_resource = DummyCard.new(:card_type => CardType.new)
      encoded = dummy_resource.encode(:root => 'dummy_card')
      encoded.should == xml
    end
    
    it "should encode properly" do
      card = DummyCard.new(:number => 116,
      :properties => [{ :type_description => 'Any card used in tree',
        :hidden   => 'false', :name => 'Feature',
        :value    => 117}])
      expected_xml = load_fixture('single_card.xml')
      actual_xml = @card_format.encode(card.attributes, :root => 'card')
      actual_xml.should == expected_xml
    end
  end
end