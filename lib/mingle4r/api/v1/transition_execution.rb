module Mingle4r
  class API
    class V1
      class TransitionExecution
        extend Mingle4r::CommonClassMethods
        module InstanceMethods
          def execute
            conn = self.class.connection
            conn.post(self.class.collection_path, encode, self.class.headers)
          end
        end
      end
    end
  end
end