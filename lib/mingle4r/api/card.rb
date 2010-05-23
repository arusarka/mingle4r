module Mingle4r
  module API
    class Card  
      extend Mingle4r::CommonClassMethods
      
      # overwrite the default find in CommonClassMethods
      def self.find(*args)
        scope = args.slice!(0)
        options = args.slice!(0) || {}
        @resource_class.find_without_pagination(scope, options)
      end
      
      module ClassMethods
        def find_without_pagination(*args)
          scope   = args.slice!(0)
          options = args.slice!(0) || {}
          options[:params] ||= {}
          options[:params].merge!({:page => 'all'})
          # call ActiveResource::Base::find with proper options
          find(scope, options)
        end

        # applies an mql filter on card types. Look at https://mingle05.thoughtworks.com/help/mql_reference.html
        # for reference
        def apply_filter(filter_string)
          find_without_pagination(:all, :params => {'filters[mql]'.to_sym => filter_string})
        end
      end

      module InstanceMethods
        # so that active resource tries to find by number
        def id
          number()
        end
        
        def type
          card_type.name
        end
        
        def type=(type)
          attributes['card_type_name'] = type
        end
        
        def attachments(refresh = false)
          return @attachments if(!refresh && @attachments)
          set_attributes_for(Attachment)
          @attachments = Attachment.find(:all)
        end
        
        def comments(refresh = false)
          return @comments if(!refresh && @comments)
          set_attributes_for(Comment)
          @comments = Comment.find(:all)
        end
        
        def transitions(refresh = false)
          return @transitions if(!refresh && @transitions)
          set_attributes_for(Transition)
          @transitions = Transition.find(:all)
        end
        
        def murmurs(refresh = false)
          return @murmurs if(!refresh && @murmurs)
          set_attributes_for(Murmur)
          @murmurs = Murmur.find(:all)
        end
        
        def upload_attachment(file_path)
          attachment_uri   = URI.parse(File.join(self.class.site.to_s, "cards/#{self.number()}/attachments.xml"))
          http             = Net::HTTP.new(attachment_uri.host, attachment_uri.port)
          http.use_ssl     = attachment_uri.is_a?(URI::HTTPS)
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE if http.use_ssl
          basic_encode     = 'Basic ' + ["#{self.class.user}:#{self.class.password}"].pack('m').delete("\r\n")

          post_headers = {
            'Authorization' => basic_encode,
            'Content-Type'  => 'multipart/form-data; boundary=----------XnJLe9ZIbbGUYtzPQJ16u1'
          }

          file_content = IO.read(file_path)

          post_body = <<EOS
------------XnJLe9ZIbbGUYtzPQJ16u1\r
Content-Disposition: form-data; name="file"; filename="#{File.basename(file_path)}"\r
Content-Type: application/octet-stream\r
Content-Length: #{file_content.size}\r
\r
#{file_content}\r
------------XnJLe9ZIbbGUYtzPQJ16u1--\r
EOS
      
          http.post(attachment_uri.path, post_body, post_headers)
        end
        
        def add_comment(str)
          set_attributes_for(Comment)
          comment = Comment.new(:content => str.to_s)
          comment.save
        end
        
        def execute_transition(args)
          trans_name = args.symbolize_keys[:name]
          transition = transitions.detect { |t| t.name ==  trans_name}
          transition.execute(args)
        end
        
        # returns back the version of the card given. If an invalid version is given, the latest
        # version is returned, takes a number or :next or :before
        def version(version_no)
          version_2_find = 0
          case version_no
          when :previous
            version_2_find = self.version.to_i - 1
          when :next
            version_2_find = self.version.to_i + 1
          else
            version_2_find = version_no.to_i
          end
          self.class.find(self.number, :params => {:version => version_2_find})
        end
        
        # Gets and sets the value of a property. The property name given should be the same
        # as the mingle property name. the value is optional
        def property_value(name, val = nil)
          property = properties.detect { |p| p.name == name }
          val ? property.value = val : property.value
        end
    
        # Gets the custom properties in the form of an array of hashes with the property names as keys and
        # property values as the value
        def custom_properties
          properties.map { |p| {p.name => p.value} }
        end
        
        private
        def set_attributes_for(klass)
          resource_site  = File.join(self.class.site.to_s, "cards/#{self.number()}").to_s
          klass.site     = resource_site
          klass.user     = self.class.user
          klass.password = self.class.password
        end
      end
    end
  end
end