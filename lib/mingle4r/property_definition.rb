module Mingle4r
  class PropertyDefinition
    module InstanceMethods
    end
      
    module ClassMethods
    end
      
    extend Mingle4r::CommonClassMethods
      
    def self.column_name_for(prop_name)
      property_def = @resource_class.find(:all).detect { |prop| prop.name == prop_name }
      property_def ? property_def.column_name : nil
    end

    private
    def self.create_resource_class
      # raise exceptions if any of site, user or password is not set
      raise "Please set the site for #{self} class before using create_resource_class()." unless(self.site)
      raise "Please set the user for #{self} class before using create_resource_class()." unless(self.user)
      raise "Please set the password for #{self} class before using create_resource_class()." unless(self.password)

      created_class = Class.new(MingleResource)

      # set the resource options
      created_class.site = self.site
      created_class.user = self.user
      created_class.password = self.password
      created_class.collection_name = 'property_definitions'
      created_class.element_name = 'record'

      created_class_name = "#{self}::#{class_name}#{Mingle4r::Helpers.fast_token}"
      eval "#{created_class_name} = created_class"

      inst_meth_mod_name = instance_methods_module_name()
      created_class.send(:include, self.const_get(inst_meth_mod_name.to_sym)) if inst_meth_mod_name

      class_meth_mod_name = class_methods_module_name()
      created_class.extend(self.const_get(class_meth_mod_name)) if class_meth_mod_name

      created_class
    end
  end
end