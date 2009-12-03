module Mingle4r
  class API
    class V1
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
            scope = args.slice!(0)
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
          def attachments(refresh = false)
            return @attachments if(!refresh && @attachments_cached)
            attachment_site = File.join(self.class.site.to_s, "cards/#{self.number()}").to_s
            Attachment.site = attachment_site
            Attachment.user = self.class.user
            Attachment.password = self.class.password
            attachment_class = Attachment.send(:create_resource_class)
            @attachments = attachment_class.find(:all)
            @attachments_cached = true
            @attachments
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
      
          # returns back the version of the card given. If an invalid version is given, the latest
          # version is returned, takes a number or :next or :before
          def at_version(version_no)
            version_2_find = 0
            case version_no
            when :before
              version_2_find = self.version.to_i - 1
            when :next
              version_2_find = self.version.to_i + 1
            else
              version_2_find = version_no.to_i
            end
            self.class.find(self.number, :params => {:version => version_2_find})
          end

          # adds a comment to a card.
          def add_comment(comment)
            comment_uri = URI.parse(File.join(self.class.site.to_s, "cards/add_comment?card_id=#{self.id}"))
        
            http             = Net::HTTP.new(comment_uri.host, comment_uri.port)
            http.use_ssl     = comment_uri.is_a?(URI::HTTPS)
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE if http.use_ssl
        
            basic_encode = 'Basic ' + ["#{self.class.user}:#{self.class.password}"].pack('m').delete("\r\n")
        
            post_headers = {
              'Authorization' => basic_encode,
              'Content-Type'  => 'application/x-www-form-urlencoded; charset=UTF-8'
            }
        
            post_body = "comment=#{comment}&card_id=#{self.id}"
        
            http.post(comment_uri.path, post_body, post_headers)
          end
      
          # TODO - Check if working with https
          # Executes the given transition on the card.
          # Example :
          # defect_card.execute_transition(:name => 'Close Defect', :Owner => nil, :Status => 'Closed', :transition_comment => comment)
          # transition_comment is mandatory if the transition is set that way.
          # after transition 'Owner' would have value 'Not Set' and 'Status' would be 'Closed' for defect card
          def execute_transition(args_hash)
            project_id = File.basename(self.class.site.to_s)
            transition_name = args_hash.delete(:name)
            raise 'Transition name for given' unless transition_name
            transition_uri = URI.parse(File.join(self.class.site.to_s, 'transition_executions.xml'))
        
            # create the form data
            form_data = {
              'transition_execution[transition]' => transition_name,
              'transition_execution[card]' => self.number.to_s
            }
            comment = args_hash.delete(:transition_comment)
            form_data['transition_execution[comment]'] = Helpers.encode2html(comment) if comment
            args_hash.each do |key, value|
              form_data['transition_execution[properties][][name]'] = Helpers.encode2html(key.to_s)
              form_data['transition_execution[properties][][value]'] = Helpers.encode2html(value.to_s)
            end
        
            req = Net::HTTP::Post.new(transition_uri.path)
            req.basic_auth self.class.user, self.class.password
            req.set_form_data(form_data)
        
            Net::HTTP.new(transition_uri.host, transition_uri.port).start { |http| http.request(req) }
          end
      
          # gets the value of a property. The property name given should be the same name as
          # the mingle property name
          def property_value(name, val = nil)
            column_name = PropertyDefinition.column_name_for(name.to_s)
            val ? attributes[column_name] = val : attributes[column_name]
          end

          def custom_properties
            custom_props = []
            card_props = attributes.keys
            PropertyDefinition.find(:all).each do |prop|
              if(card_props.include?(prop.column_name))
                custom_prop = {prop.name => attributes[prop.column_name]}
                custom_props.push(custom_prop)
              end
            end
            custom_props
          end
      
          private
          def boundary
            '----------XnJLe9ZIbbGUYtzPQJ16u1'
          end
        end
      end
    end
  end
end