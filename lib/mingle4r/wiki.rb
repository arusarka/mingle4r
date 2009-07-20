module Mingle4r
  class Wiki
    extend Mingle4r::CommonClassMethods
    self.collection_name = 'wiki'
    self.element_name = 'page'
  end
end