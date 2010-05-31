module Mingle4r
  class CardFormat
    def extension
      'xml'
    end
    
    def mime_type
      'application/xml'
    end
    
    def decode(xml)
      cards = from_xml_data(Hash.from_xml(xml))
      simplify_prop_tags_of_type('Any card used in tree', cards)
      simplify_prop_tags_of_type('Card', cards)
      convert_card_type_tag(cards)
      cards
    end
    
    def encode(hash, options={})
      options.merge! :dasherize => false
      # convert_link_props_of_type('Any card used in tree', hash)
      # convert_link_props_of_type('Card', hash)
      hash.to_xml(options)
    end

    private
    def from_xml_data(data)
      if data.is_a?(Hash) && data.keys.size == 1
        data.values.first
      else
        data
      end
    end
    
    def convert_link_props_of_type(type, hash)
      return unless hash['properties']
      hash['properties'].collect! do |prop|
        convert_link_prop(prop) if (prop_of_type?(prop, type))
        prop
      end
      hash
    end

    def convert_link_prop(prop)
      prop.value = prop.value.number if prop.value
      prop
    end
    
    def prop_of_type?(prop, type)
      prop.type_description == type
    end
    
    def simplify_prop_tags_of_type(type, cards)
      cards.collect! { |card| simplify_card_for_prop_tags_of_type(card, type) }
    end
    
    def simplify_card_for_prop_tags_of_type(card, type)
      return card unless card['properties']
      card['properties'].collect! do |prop|
        simplify_prop(prop) if (prop_is_of_type?(prop, type))
        prop
      end
      card
    end
    
    def simplify_prop(prop)
      prop['value'] = prop['value']['number'] if prop['value']
      prop
    end
    
    def prop_is_of_type?(prop, type)
      prop['type_description'] == type
    end
    
    def convert_card_type_tag(cards)
      cards.collect! do |card|
        card_type = card.delete('card_type')
        card['card_type_name'] = card_type['name']
        card
      end
    end
  end
end