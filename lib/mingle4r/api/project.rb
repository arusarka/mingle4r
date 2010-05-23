module Mingle4r
  module API
    class Project
      module InstanceMethods
        # returns the cards for the project.
        def cards
          set_attributes_for(Card) unless card_class_set
          Card.find_without_pagination(:all)
        end

        # returns the users for the project.
        def users
          set_attributes_for(User) unless user_class_set
          User.find(:all)
        end

        # returns the wikis for the project.
        def wikis
          set_attributes_for(Wiki) unless wiki_class_set
          Wiki.find(:all)
        end

        # returns the property definitions for the project.
        def property_definitions
          set_attributes_for(PropertyDefinition)
          PropertyDefinition.find(:all)
        end

        # returns the murmurs for the project.
        def murmurs
          set_attributes_for(Murmur)
          Murmur.find(:all)
        end

        # posts a murmur
        def post_murmur(str)
          set_attributes_for(Murmur)
          murmur = Murmur.new(:body => str.to_s)
          murmur.save
        end
        
        # executes an mql
        def execute_mql(query)
          set_attributes_for(ExecuteMql)
          ExecuteMql.query(query)
        end
        
        private
        def set_attributes_for(klass)
          resource_site = File.join(self.class.site.to_s, "projects/#{self.identifier}")
          resource_site = File.join(resource_site, 'cards') if klass == ExecuteMql
          klass.site = resource_site
          klass.user = self.class.user
          klass.password = self.class.password
          setter_method = klass.name.demodulize.downcase + '_class_set'
          send(setter_method, true)
          klass
        end
        
        def user_class_set(val = nil)
          return @user_class_set unless val
          @user_class_set = val
        end
        
        def card_class_set(val = nil)
          return @card_class_set unless val
          @card_class_set = val
        end
        
        def wiki_class_set(val = nil)
          return @wiki_class_set unless val
          @wiki_class_set = val
        end
      end # module InstanceMethods

      extend Mingle4r::CommonClassMethods
    end # class Project
  end # class API
end