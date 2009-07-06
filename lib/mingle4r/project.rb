module Mingle4r
  class Project
    module InstanceMethods
      def cards
        return @cards if @cards
        cards_site = File.join(self.class.site.to_s, "projects/#{self.identifier()}")
        Mingle4r::Card.site = cards_site
        Mingle4r::Card.user = self.class.user
        Mingle4r::Card.password = self.class.password
        card_class = Mingle4r::Card.send(:create_resource_class)
        @cards = card_class.find_without_pagination(:all)
      end
    end # module InstanceMethods
    
    extend Mingle4r::CommonClassMethods
  end # class Project
end