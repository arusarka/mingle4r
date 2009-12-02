module Mingle4r
  class API
    class V2
      class Card
        class Comment
          module InstanceMethods
            def to_s
              attributes['content']
            end
          end
          extend Mingle4r::CommonClassMethods
        end
      end
    end
  end
end