require 'mingle4r/card/attachment'

module Mingle4r
  class Card
    module ClassMethods
      def find_without_pagination(*args)
        scope = args.slice!(0)
        options = args.slice!(0) || {}
        options.merge!(:params => {:page => 'all'}) if (scope == :all)

        # call ActiveResource::Base::find with proper options
        find(scope, options)
      end
    end
    
    module InstanceMethods
      def attachments
        return @attachments if @attachments
        attachment_site = File.join(self.class.site.to_s, "cards/#{self.number()}").to_s
        Mingle4r::Card::Attachment.site = attachment_site
        Mingle4r::Card::Attachment.user = self.class.user
        Mingle4r::Card::Attachment.password = self.class.password
        attachment_class = Mingle4r::Card::Attachment.send(:create_resource_class)
        @attachments = attachment_class.find(:all)
      end

      def upload_attachment(file_path)
        attachment_url = File.join(self.class.site.to_s, "projects/#{self.number()}/attachments.xml")
        req = Net::HTTP::Post.new(attachment_url.path)
        basic_encode = 'Basic ' + ["#{self.class.user}:#{self.class.password}"].pack('m').delete("\r\n")
        req.initialize_http_header({ 'Content-Type' => "multipart/form-data; boundary=#{boundary()}", 'authorization' => basic_encode})

        file_content = IO.open(file_path)

        post_body = <<-EOS
        #{boundary()}\r
        Content-Disposition: form-data; name="file"; filename="#{File.basename(file_path)}"\r
        Content-Type: application/octet-stream\r
        Content-Length: #{file_content.size}\r
        \r
        #{file_content}\r
        #{boundary()}--\r
        EOS

        req.body = post_body
        Net::HTTP.new(attachment_url.host, attachment_url.port).start { |http| http.request(req) }
      end
      
      # returns back the version of the card given. If an invalid version is given, the latest
      # version is returned, takes a number, :next and :before
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

      private
      def boundary
        '----------XnJLe9ZIbbGUYtzPQJ16u1'
      end
    end

    extend Mingle4r::CommonClassMethods
  end
end