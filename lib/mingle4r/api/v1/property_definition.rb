module Mingle4r
  class API
    class V1
      class PropertyDefinition
        extend Mingle4r::CommonClassMethods

        def self.column_name_for(prop_name)
          property_def = @resource_class.find(:all).detect { |prop| prop.name == prop_name }
          property_def ? property_def.column_name : nil
        end
      end
    end
  end
end

Mingle4r::API::V1::PropertyDefinition.element_name = 'record'