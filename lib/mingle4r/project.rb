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
      
      def users
        return @users if @users
        users_site = File.join(self.class.site.to_s, "projects/#{self.identifier()}")
        Mingle4r::User.site = users_site
        Mingle4r::User.user = self.class.user
        Mingle4r::User.password = self.class.password
        user_class = Mingle4r::User.send(:create_resource_class)
        @users = user_class.find(:all)
      end
      
      def wiki
        return @wiki if @wiki
        wiki_site = File.join(self.class.site.to_s, "projects/#{self.identifier()}")
        Mingle4r::Wiki.site = wiki_site
        Mingle4r::Wiki.user = self.class.user
        Mingle4r::Wiki.password = self.class.password
        wiki_class = Mingle4r::Wiki.send(:create_resource_class)
        @wiki = wiki_class.find(:all)
      end
    end # module InstanceMethods
    
    extend Mingle4r::CommonClassMethods
  end # class Project
end