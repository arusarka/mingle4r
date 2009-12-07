module Mingle4r
  module API
    class Wiki
      extend Mingle4r::CommonClassMethods
    end
  end
end

Mingle4r::API::Wiki.collection_name = 'wiki'
Mingle4r::API::Wiki.element_name = 'page'