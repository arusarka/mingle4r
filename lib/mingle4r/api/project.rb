module Mingle4r
  module API
    class Project
      module InstanceMethods
        # returns the cards for the project.
        def cards
          set_attributes_for(Card)
          Card.find_without_pagination(:all)
        end

        # returns the users for the project.
        def users
          set_attributes_for(User)
          User.find(:all)
        end

        # returns the wikis for the project.
        def wikis
          set_attributes_for(Wiki)
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
        
        #finds a single card
        def find_card(number)
          set_attributes_for(Card)
          Card.find(number)
        end
        
        #returns a filtered list of cards
        def filter_cards(filter_str)
          set_attributes_for(Card)
          Card.apply_filter(filter_str)
        end
        
        def new_card
          set_attributes_for(Card)
          Card.new
        end
        
        private
        def set_attributes_for(klass)
          resource_site = File.join(self.class.site.to_s, "projects/#{self.identifier}")
          resource_site = File.join(resource_site, 'cards') if klass == ExecuteMql
          klass.site = resource_site
          klass.user = self.class.user
          klass.password = self.class.password
          klass
        end
      end # module InstanceMethods

      extend Mingle4r::CommonClassMethods
      
      private
      def self.on_setup(klass)
        klass.primary_key = 'identifier'
      end
    end # class Project
  end # class API
end