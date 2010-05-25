require File.dirname(__FILE__) + '/../spec_helper'

include Mingle4r

class DummyCard < ActiveResource::Base ; end
class CardType < ActiveResource::Base ; end

describe CardFormat do
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
      <card><name>Yet another bug</name>
        <card_type_name>Bug</card_type_name>
        <properties type="array">
          <property type_description="Card" hidden="false">
            <name>Defect Fix Completed in Iteration</name>
            <value type="integer">34</value>
          </property>
        </properties>
      </card>
XML
      @card_format.decode(xml).should == {"name"=>"Yet another bug", "card_type_name"=>"Bug",
        "properties"=>[{"name"=>"Defect Fix Completed in Iteration", "type_description"=>"Card", "value"=>34, "hidden"=>"false"}]}
    end
  end

  context "encode" do
    it "should be able to encode properly" do
      xml = '<?xml version="1.0" encoding="UTF-8"?>' + "\n" +
      "<dummy_card>\n" +
      "  <card_type>\n" +
      "  </card_type>\n" +
      "</dummy_card>\n"
      DummyCard.site = 'http://dummyhost'
      DummyCard.format = @card_format
      dummy_resource = DummyCard.new(:card_type => CardType.new)
      encoded = dummy_resource.encode(:root => 'dummy_card')
      encoded.should == xml
    end
    
    it "should convert tree relationship property appropriately" do
      raw_xml = load_fixture('card_with_tree_relationship_property_raw.xml')
      final_xml = load_fixture('card_with_tree_relationship_property_final.xml')
      hash_to_encode = @card_format.decode(raw_xml)
      encoded_xml = @card_format.encode(hash_to_encode, :root => 'card')
      encoded_xml.should == final_xml
    end
    
    it "should convert card relationship property appropriately" do
      raw_xml = load_fixture('card_with_card_relationship_property_raw.xml')
      final_xml = load_fixture('card_with_card_relationship_property_final.xml')
      hash_to_encode = @card_format.decode(raw_xml)
      encoded_xml = @card_format.encode(hash_to_encode, :root => 'card')
      encoded_xml.should == final_xml
    end
  end
end