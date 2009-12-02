module Mingle4r
  class API
    class V2
      def initialize(host_url)
        @host_uri = URI.parse(host_url)
      end
      
      def base_url
        File.join(@host_uri.to_s, '/api/v2')
      end
      
      def version
        2
      end
      
      def project_class
        Project
      end
      
      def user_class
        User
      end
    end
  end
end