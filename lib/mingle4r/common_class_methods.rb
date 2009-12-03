module Mingle4r
  # ActiveResource makes connecting to rest resources very easy. However it has one problem 
  # and a big one at that. If you try setting the authentication credentials or the site or
  # collection name, element name for the class for the second time it doesn't work. E.g.
  #
  # class Person < ActiveResource::base
  #   self.site = 'http://localhost:9090/'
  # end
  #
  # After sometime you change it to 
  #
  # Person.site = 'https://org-server/my_proj/'
  # Person.user = 'admin'
  # Person.password = 'secret'
  #
  # Then you do
  #
  # Person.find(:all) => It bombs
  #
  # This module provides a mechanism by which you can get rid of this problem. Extend this
  # class in the actual class itself. Do not extend the extended class from ActiveResource::Base.
  # 
  # E.g.
  #
  # class Person
  #  extend CommonClassMethods
  # end
  #
  # set the credentials
  #
  # Person.site = 'http://localhost:8080'
  # Person.user = 'foo'
  # Person.password = 'bar'
  # 
  # Thats it. Now create some objects
  #
  # asur = Person.new(:name => 'Asur', :job => 'fooling around', :status => 'Single and ready 2 mingle')
  # asur.save
  # 
  # Now change the class attributes
  #
  # Person.site = 'https://org-server/mingle'
  # Person.collection_name = 'boring_people'
  # 
  # Now instantiate an object
  #
  # rakhshas = Person.new(:name => 'Rakhshas', :job => 'eating people', :status => 'just woke up and hungry')
  # rakhshas.save => Voila !!!!!!! it works
  # 
  # CUSTOMIZATIONS
  # --------------
  # 
  # No amount of wrapping can provide very detailed customizations. Either you have a lot of methods
  # that are not being used or there is hardly anything at all. To oversome this problem this module
  # was written to provide only those methods which are common to most active resource objects.
  # However if you want to have a little more control over your active resource objects its very easy.
  # Here's how you would do it normally
  # 
  # class Person < ActiveResource::Base
  #   def self.count
  #     find(:all).size
  #   end
  #
  #   def occupation
  #     return job if job
  #     'Unemployed' 
  #   end
  # end
  #
  # To do the same thing, here's how you do it using this library
  #
  # class Person
  #   module ClassMethods
  #     def count
  #       find(:all).size
  #     end
  #   end
  #
  #   module InstanceMethods
  #     def occupation
  #       return job if job
  #       'Unemployed' 
  #     end
  #   end
  #   extend CommonClassMethods
  # end
  #
  # The instance methods will be available as instance methods in the objects created, class methods
  # will be available as class methods in the class of the object.
  
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
      # raise exceptions if site is not set
      raise "Please set the site for #{self} class." unless(self.site)
      
      created_class = Class.new(MingleResource)
      
      # set the resource options
      created_class.site = self.site
      created_class.user = self.user
      created_class.password = self.password
      created_class.collection_name = self.collection_name
      created_class.element_name = self.element_name

      # created_class_name = "#{self}::#{class_name}#{Mingle4r::Helpers.fast_token()}"
      created_class_name = class_name + Mingle4r::Helpers.fast_token()
      created_class = self.const_set(created_class_name, created_class)
      # eval "#{created_class_name} = created_class"

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
      @resource_class.send(meth_id.to_sym, *args, &block)
    end
  end
end