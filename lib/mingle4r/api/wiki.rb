module Mingle4r
  module API
    class Wiki
      extend Mingle4r::CommonClassMethods

      module InstanceMethods
        def attachments
          ensure_attachment_resource_configured!
          @attachments = Attachment.find(:all)
        end

        def ensure_attachment_resource_configured!
          unless @attachment_resource_configured
            Attachment.site     = URI.join(self.class.site.to_s, "wiki/#{self.identifier()}").to_s
            Attachment.user     = self.class.user
            Attachment.password = self.class.password
            @attachment_resource_configured = true
          end
        end
      end

      private
      def self.on_setup(klass)
        klass.primary_key = 'identifier'
      end
    end
  end
end

Mingle4r::API::Wiki.collection_name = 'wiki'
Mingle4r::API::Wiki.element_name = 'page'
