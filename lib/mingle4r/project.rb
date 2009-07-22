module Mingle4r
  class Project
    module InstanceMethods
      # returns the cards for the project. To hit the resource server without returning
      # cached results pass true as an argument.
      def cards(refresh = false)
        return @cards if(!refresh && @cards_cached)
        cards_site = File.join(self.class.site.to_s, "projects/#{self.identifier()}")
        Mingle4r::Card.site = cards_site
        Mingle4r::Card.user = self.class.user
        Mingle4r::Card.password = self.class.password
        card_class = Mingle4r::Card.send(:create_resource_class)
        @cards = card_class.find_without_pagination(:all)
        @cards_cached = true
        @cards
      end
      
      # returns the users for the project. To hit the resource server without returning
      # cached results pass true as an argument.
      def users(refresh = false)
        return @users if(!refresh && @users_cached)
        users_site = File.join(self.class.site.to_s, "projects/#{self.identifier()}")
        Mingle4r::User.site = users_site
        Mingle4r::User.user = self.class.user
        Mingle4r::User.password = self.class.password
        Mingle4r::User.element_name = nil # reset
        user_class = Mingle4r::User.send(:create_resource_class)
        @users = user_class.find(:all)
        @users_cached = true
        @users
      end
      
      # returns the wikis for the project. To hit the resource server without returning
      # cached results pass true as an argument.
      def wikis(refresh = false)
        return @wikis if(!refresh && @wikis_cached)
        wiki_site = File.join(self.class.site.to_s, "projects/#{self.identifier()}")
        Mingle4r::Wiki.site = wiki_site
        Mingle4r::Wiki.user = self.class.user
        Mingle4r::Wiki.password = self.class.password
        wiki_class = Mingle4r::Wiki.send(:create_resource_class)
        @wikis = wiki_class.find(:all)
        @wikis_cached = true
        @wikis
      end
      
      # returns the property definitions for the project. To hit the resource server
      # pass true as an argument
      def property_definitions(refresh = false)
        return @prop_definitions if(!refresh && @prop_definitions_cached)
        properties_site = File.join(@site.to_s, "projects/#{self.identifier}")
        PropertyDefinition.site = properties_site
        PropertyDefinition.user = @user
        PropertyDefinition.password = @password
        prop_defn_class = Mingle4r::PropertyDefinition.send(:create_resource_class)
        @prop_definitions = prop_defn_class.find(:all)
        @prop_definitions_cached = true
        @prop_definitions
      end
    end # module InstanceMethods
    
    extend Mingle4r::CommonClassMethods
  end # class Project
end