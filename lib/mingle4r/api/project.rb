module Mingle4r
  module API
    class Project
      module InstanceMethods
        # returns the cards for the project. To hit the resource server without returning
        # cached results pass true as an argument.
        def cards(refresh = false)
          return @cards if(!refresh && @cards)
          set_attributes_for(Card)
          @cards = Card.find_without_pagination(:all)
        end

        # returns the users for the project. To hit the resource server without returning
        # cached results pass true as an argument.
        def users(refresh = false)
          return @users if(!refresh && @users)
          set_attributes_for(User)
          @users = User.find(:all)
        end

        # returns the wikis for the project. To hit the resource server without returning
        # cached results pass true as an argument.
        def wikis(refresh = false)
          return @wikis if(!refresh && @wikis)
          set_attributes_for(Wiki)
          @wikis = Wiki.find(:all)
        end

        # returns the property definitions for the project. To hit the resource server
        # pass true as an argument
        def property_definitions(refresh = false)
          return @prop_definitions if(!refresh && @prop_definitions)
          set_attributes_for(PropertyDefinition)
          @prop_definitions = PropertyDefinition.find(:all)
        end

        # returns the murmurs for the project. To hit the resource server without returning
        # cached results pass true as an argument.
        def murmurs(refresh = false)
          return @murmurs if(!refresh && @murmurs)
          set_attributes_for(Murmur)
          @murmurs = Murmur.find(:all)
        end

        # posts a murmur
        def post_murmur(str)
          set_attributes_for(Murmur)
          murmur = Murmur.new(:body => str.to_s)
          murmur.save
        end
        
        private
        def set_attributes_for(klass)
          resource_site = File.join(self.class.site.to_s, "projects/#{self.identifier}")
          klass.site = murmurs_site
          klass.user = self.class.user
          klass.password = self.class.password
        end
      end # module InstanceMethods

      extend Mingle4r::CommonClassMethods
    end # class Project
  end # class API
end