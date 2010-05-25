module Mingle4r
  module API
    class Wiki
      extend Mingle4r::CommonClassMethods
      
      module InstanceMethods
        def id
          identifier
        end
      end
      
      private
      def self.on_setup(klass)
        klass.primary_key = 'identifier'
      end
    end
  end
end

Mingle4r::API::Wiki.collection_name = 'wiki'
Mingle4r::API::Wiki.element_name = 'page'