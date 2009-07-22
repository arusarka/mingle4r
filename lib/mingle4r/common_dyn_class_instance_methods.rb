module Mingle4r
  # common dynamic class instance methods
  module CommonDynClassInstanceMethods
    # gets the value of a property. The property name can be given in several ways.
    # suppose we are trying to get the property 'Iteration Number' as in mingle
    #
    # 1) give the name as seen card.property_value('Iteration Number')
    #
    # 2) give the property method name i.e. in the active resource object it would
    # become by default 'cp_iteration_number' attribute unless set differently in
    # Mingle
    #
    # 3) give the method a 'space separated' / 'camelcased' method name. e.g. - 'Iteration Number'
    # 'IterationNumber'
    def property_value(prop_name)
      begin
        column_name = PropertyDefinition.column_name_for(prop_name.to_s)
        self.send(column_name.to_sym) 
      rescue NoMethodError
        if self.attributes.has_key?(prop_name)
          self.attributes[prop_name]
        else
          # try calling a underscorized method. eg 'Iteration Number' becomes
          # 'iteration_number'
          method_id = (prop_name.split(' ').map { |substring| substring.downcase }).join('_').underscore.to_sym
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