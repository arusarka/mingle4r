module Mingle4r
  class API
    class V1
      def initialize(host_url)
        @host_uri = URI.parse(host_url)
      end
      
      def base_url
        @host_uri.to_s
      end
      
      def version
        1
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