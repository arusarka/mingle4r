module Mingle4r
  class CardFormat
    def extension
      'xml'
    end
    
    def mime_type
      'application/xml'
    end
    
    def decode(xml)
      data = from_xml_data(Hash.from_xml(xml))
      simplify_properties(data)
      data
    end
    
    def encode(hash, options={})
      options.merge! :dasherize => false
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
    
    def simplify_properties(data)
      types_to_convert = ['Any card used in tree', 'Card',
        'Automatically generated from the team list']
      types_to_convert.each { |type| convert_prop_tags_of_type(type, data)}
      convert_card_type_tag(data)
    end
    
    def for_every_card_in(data, &block)
      if data.is_a?(Hash) && data.keys.size == 1
        block.call(data['card'])
      else
        data.collect! { |card| block.call(card) }
      end      
    end
    
    def convert_prop_tags_of_type(type, data)
      for_every_card_in(data) { |card| convert_card_for_prop_tags_of_type(card, type) }
    end
    
    def convert_card_for_prop_tags_of_type(card, type)
      return card unless card['properties']
      card['properties'].collect! do |prop|
        convert_prop(prop) if (prop_is_of_type?(prop, type))
        prop
      end
      card
    end
    
    def convert_prop(prop)
      if prop_is_of_type?(prop, 'Automatically generated from the team list')
        prop = convert_team_member_prop(prop)
      else
        prop['value'] = prop['value']['number'] if prop['value']
      end
      prop
    end
    
    def convert_team_member_prop(prop)
      return prop unless prop['value']
      url = prop['value']['url']
      prop['value'] = File.basename(url).gsub('.xml', '').to_i
      prop
    end
    
    def prop_is_of_type?(prop, type)
      prop['type_description'] == type
    end
    
    def convert_card_type_tag(data)
      for_every_card_in(data) do |card|
        card_type = card.delete('card_type')
        card['card_type_name'] = card_type['name']
        card
      end
    end
  end
end