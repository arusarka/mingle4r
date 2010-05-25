module Mingle4r
  class CardFormat
    def extension
      'xml'
    end
    
    def mime_type
      'application/xml'
    end
    
    def decode(xml)
      from_xml_data(Hash.from_xml(xml))
    end
    
    def encode(hash, options={})
      options.merge! :dasherize => false
      convert_link_props_of_type(hash, 'Any card used in tree')
      convert_link_props_of_type(hash, 'Card')
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
    
    def convert_link_props_of_type(hash, type)
      return unless hash['properties']
      hash['properties'].collect! do |prop|
        convert_link_prop(prop) if (prop_of_type?(prop, type))
        prop
      end
      hash
    end

    def convert_link_prop(prop)
      prop['value'] = prop['value']['number'] if prop['value']
      prop
    end
    
    def prop_of_type?(prop, type)
      prop['type_description'] == type
    end
  end
end