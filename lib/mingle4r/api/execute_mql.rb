module Mingle4r
  module API
    class ExecuteMql
      extend Mingle4r::CommonClassMethods
      
      def self.query(query_string)
        @resource_class.find(:all, :params => {:mql => query_string})
      end
    end
  end
end

Mingle4r::API::ExecuteMql.collection_name = 'execute_mql'
Mingle4r::API::ExecuteMql.element_name = 'result'