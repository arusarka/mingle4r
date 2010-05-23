module Mingle4r
  class MingleFormat
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
  end
end