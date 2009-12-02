module Mingle4r
  class API
    class V1
      class Wiki
        extend Mingle4r::CommonClassMethods
      end
    end
  end
end

Mingle4r::API::V1::Wiki.collection_name = 'wiki'
Mingle4r::API::V1::Wiki.element_name = 'page'