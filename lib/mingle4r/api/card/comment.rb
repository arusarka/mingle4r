module Mingle4r
  module API
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