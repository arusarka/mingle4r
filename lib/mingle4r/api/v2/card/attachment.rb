module Mingle4r
  class API
    class V2
      class Card
        class Attachment
          module InstanceMethods
            # downloads the attachment. It an additional file path is given it saves it at the 
            # given path. The given path should be writable
            def download(file_name = nil)
              collection_uri = self.class.site
              rel_down_url = self.url
              base_url = "#{collection_uri.scheme}://#{collection_uri.host}:#{collection_uri.port}/"
              down_uri = URI.join(base_url, rel_down_url)
              req = Net::HTTP::Get.new(down_uri.path)
              req.basic_auth self.class.user, self.class.password
              begin
                res = Net::HTTP.start(down_uri.host, down_uri.port) { |http| http.request(req) }
                file_name ||= self.file_name()
                File.open(file_name, 'w') { |f| f.print(res.body) }
              rescue Exception => e
                e.message
              end
            end # download

            # alias for file_name
            def name
              file_name()
            end

            # so that active resource tries to find by proper id
            def id
              name()
            end

            # This method had to be overriden. 
            # normal active resource destroy doesn't work as mingle site for deleting attachments doesn't end with .xml.
            def destroy
              connection = self.send(:connection)
              # deletes the attachment by removing .xml at the end
              connection.delete(self.send(:element_path).gsub(/\.xml\z/, ''))
            end
            alias_method :delete, :destroy
          end #module InstanceMethods

          extend Mingle4r::CommonClassMethods

        end # class Attachment
      end # class Card
    end # class V2
  end # class API
end # module Mingle4r