module Mingle4r
  class CardFormat
    def extension
      'xml'
    end
    
    def mime_type
      'application/xml'
    end
    
    def decode(xml)
      hash = from_xml_data(Hash.from_xml(xml))
      simplify_props_of_type('Any card used in tree', hash)
      simplify_props_of_type('Card', hash)
      convert_card_type(hash)
      hash
    end
    
    def encode(hash, options={})
      options.merge! :dasherize => false
      convert_link_props_of_type('Any card used in tree', hash)
      convert_link_props_of_type('Card', hash)
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
    
    def simplify_props_of_type(type, hash)
      return unless hash['properties']
      hash['properties'].collect! do |prop|
        simplify_prop(prop) if (prop_is_of_type?(prop, type))
        prop
      end
      hash
    end
    
    def simplify_prop(prop)
      prop['value'] = prop['value']['number'] if prop['value']
      prop
    end
    
    def prop_is_of_type?(prop, type)
      prop['type_description'] == type
    end
    
    def convert_card_type(hash)
      card_type = hash.delete('card_type')
      hash['card_type_name'] = card_type['name']
      hash
    end
  end
end