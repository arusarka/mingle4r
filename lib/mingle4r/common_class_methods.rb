module Mingle4r
  class ResourceNotSetup < Exception; end
  
  module CommonClassMethods
    attr_reader :site, :user, :password

    # creates an object of the class in which this module is extended
    def new(args = {})
      # @resource_class ||= create_resource_class() # should this be commented
      @resource_class.new(args)
    end
    
    # sets the site for the class in which this module is extended
    def site=(site)
      if site != self.site
        @site = site
        uri = URI.parse(site)
        @user = URI.decode(uri.user) if(uri.user)
        @password = URI.decode(uri.password) if(uri.password)
        @resource_class = self.send(:create_resource_class)
      end
      @site
    end

    # sets the user for the class in which this module is extended
    def user=(user)
      if user != self.user
        @user = user
        @resource_class = self.send(:create_resource_class) if(site)
      end
      @user
    end

    # sets the password for the class in which this module is extended
    def password=(password)
      if password != self.password
        @password = password
        @resource_class = self.send(:create_resource_class) if(site)
      end
      @password
    end
    
    # sets the collection name for the class in which this module is extended
    def collection_name=(collection_name)
      if collection_name != self.collection_name
        @collection_name = collection_name
      end
      @collection_name
    end
    
    # sets the elment name for the class in which this module is extended
    def element_name=(element_name)
      if element_name != self.element_name
        @element_name = element_name
      end
      @element_name
    end
    
    # collection name for the class in which this module is extended
    def collection_name
      @collection_name || class_name.underscore.pluralize
    end
    
    # element name for the class in which this module is extended
    def element_name
      @element_name || class_name.underscore
    end
    
    # def all_attributes_set?
    #   site && user && password
    # end
    
    # routes to active resource find
    def find(*args)
      scope = args.slice!(0)
      options = args.slice!(0) || {}
      @resource_class.find(scope, options)
    end
    
    private
    # creates an active resource class dynamically. All the attributes are set automatically. Avoid calling
    # this method directly                                                  
    def create_resource_class
      raise "Please set the site for #{self} class." unless(self.site)
      created_class = Class.new(MingleResource)
      setup_class(created_class)
      created_class
    end
    
    def setup_class(klass)
      set_resource_options(klass)
      set_class_name(klass)
      include_instance_methods(klass)
      include_singleton_methods(klass)
    end
    
    def include_singleton_methods(klass)
      klass.extend(self.const_get(:ClassMethods)) if has_class_meths_module?
    end
    
    def include_instance_methods(klass)
      klass.send(:include, self.const_get(:InstanceMethods)) if has_inst_meths_module?
    end
    
    def set_class_name(klass)
      created_class_name = class_name + Mingle4r::Helpers.fast_token()
      klass = self.const_set(created_class_name, klass)
      klass
    end
    
    def set_resource_options(klass)
      klass.site = self.site
      klass.user = self.user
      klass.password = self.password
      klass.collection_name = self.collection_name
      klass.element_name = self.element_name
      klass
    end
    
    def class_name
      self.name.demodulize
    end
    
    def has_inst_meths_module?
      self.constants.detect { |const| const.demodulize == 'InstanceMethods' }
    end
    
    def has_class_meths_module?
      self.constants.detect { |const| const.demodulize == 'ClassMethods' }
    end
    
    def method_missing(meth_id, *args, &block)
      raise ResourceNotSetup.new("Site is not set for #{name}. Please set it.") unless @resource_class
      @resource_class.send(meth_id.to_sym, *args, &block)
    end
  end
end