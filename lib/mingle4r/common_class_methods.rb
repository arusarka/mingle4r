module Mingle4r
  module CommonClassMethods
    attr_reader :site, :user, :password

    def new(args = {})
      # @resource_class = create_resource_class() # should this be commented
      @resource_class.new(args)
    end
    
    def site=(site)
      if site != self.site
        @site = site
        uri = URI.parse(site)
        @user = URI.decode(uri.user) if(uri.user)
        @password = URI.decode(uri.password) if(uri.password)
        @resource_class = self.send(:create_resource_class) if(all_attributes_set?)
      end
      @site
    end

    def user=(user)
      if user != self.user
        @user = user
        @resource_class = self.send(:create_resource_class) if(all_attributes_set?)
      end
      @user
    end

    def password=(password)
      if password != self.password
        @password = password
        @resource_class = self.send(:create_resource_class) if(all_attributes_set?)
      end
      @password
    end
    
    def collection_name=(collection_name)
      if collection_name != self.collection_name
        @collection_name = collection_name
      end
      @collection_name
    end
    
    def element_name=(element_name)
      if element_name != self.element_name
        @element_name = element_name
      end
      @element_name
    end
    
    def collection_name
      @collection_name || class_name.underscore.pluralize
    end
    
    def element_name
      @element_name || class_name.underscore
    end
    
    def all_attributes_set?
      site && user && password
    end
    
    def find(*args)
      scope = args.slice!(0)
      options = args.slice!(0) || {}
      obj = @resource_class.find(scope, options)
      obj
    end
    
    private
    def create_resource_class
      # raise exceptions if any of site, user or password is not set
      raise "Please set the site for #{self} class before using create_resource_class()." unless(self.site)
      raise "Please set the user for #{self} class before using create_resource_class()." unless(self.user)
      raise "Please set the password for #{self} class before using create_resource_class()." unless(self.password)
      
      created_class = Class.new(MingleResource)
      
      # set the resource options
      created_class.site = self.site
      created_class.user = self.user
      created_class.password = self.password
      created_class.collection_name = self.collection_name
      created_class.element_name = self.element_name

      created_class_name = "#{self}::#{class_name}#{Mingle4r::Helpers.fast_token()}"
      eval "#{created_class_name} = created_class"

      # includes a module called InstanceMethods in the class created dynamically
      # if it is defined inside the wrapper class
      inst_meth_mod_name = instance_methods_module_name()
      created_class.send(:include, self.const_get(inst_meth_mod_name.to_sym)) if inst_meth_mod_name
      created_class.send(:include, Mingle4r::CommonDynClassInstanceMethods)

      # extends the class created dynamically with a module called ClassMethods if
      # it is defined inside the wrapper class
      class_meth_mod_name = class_methods_module_name()
      created_class.extend(self.const_get(class_meth_mod_name)) if class_meth_mod_name
        
      created_class
    end
    
    def class_name
      # FIXME - what if the class name is SVNConfiguration ?
      self.name.split('::')[-1]
    end
    
    def instance_methods_module_name
      inst_meth_mod_name = 'InstanceMethods'
      self.constants.detect { |const| const.split('::')[-1] =~ /#{inst_meth_mod_name}/ }
    end
    
    def class_methods_module_name
      class_meth_mod_name = 'ClassMethods'
      self.constants.detect { |const| const.split('::')[-1] =~ /#{class_meth_mod_name}/ }
    end
    
    def method_missing(meth_id, *args, &block)
      @resource_class.send(meth_id, *args, &block)
    end
  end
end