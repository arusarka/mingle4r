module Mingle4r
  class API
    class V2
      class Murmur
        extend Mingle4r::CommonClassMethods
        module InstanceMethods
          def to_s
            author.name.to_s + ' - ' + body
          end
        end
      end
    end
  end
end