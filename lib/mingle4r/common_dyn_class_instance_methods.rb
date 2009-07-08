module Mingle4r
  # common dynamic class instance methods
  module CommonDynClassInstanceMethods
    def property_value(prop_name)
      begin
        column_name = PropertyDefinition.column_name_for(prop_name.to_s)
        self.send(column_name.to_sym) 
      rescue NoMethodError
        method_id = prop_name.to_sym
        if self.respond_to?(method_id)
          self.send(method_id)
        else
          # try calling a underscorized method. eg 'Iteration Number' becomes
          # 'iteration_number'
          method_id = prop_name.underscore.to_sym
          self.send(method_id)
        end
      end
    end
    
    def custom_properties
      custom_props = []
      props = attributes.keys
      PropertyDefinition.find(:all).each do |prop|
        custom_props << {prop.name => prop.column_name} if(props.include?(prop.column_name))
      end
      custom_props
    end
  end
end