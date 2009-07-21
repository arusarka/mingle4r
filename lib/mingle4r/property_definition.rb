module Mingle4r
  class PropertyDefinition
    # module InstanceMethods
    # end
    #   
    # module ClassMethods
    # end
    #   
    extend Mingle4r::CommonClassMethods
    
    self.element_name = 'record'
      
    def self.column_name_for(prop_name)
      property_def = @resource_class.find(:all).detect { |prop| prop.name == prop_name }
      property_def ? property_def.column_name : nil
    end
  end
end