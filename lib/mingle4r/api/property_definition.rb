module Mingle4r
  module API
    class PropertyDefinition
      extend Mingle4r::CommonClassMethods

      def self.column_name_for(prop_name)
        property_def = @resource_class.find(:all).detect { |prop| prop.name == prop_name }
        property_def ? property_def.column_name : nil
      end
    end
  end
end
