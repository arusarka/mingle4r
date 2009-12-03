require 'uri'
require 'net/https'

module Mingle4r
  class API
    class << self
      def create(url)
        @host_uri = URI.parse(url)
        api_ver = mingle_version.to_i - 1
        class_name = 'V' + api_ver.to_s
        ver_class = send(:const_get, class_name.to_sym)
        ver_class.new(url)
      end
      
      def mingle_version
        html  = mingle_about_page
        match = html.match('<dd>Version</dd>\n.*<dt>([_\d]*)</dt>')
        raise Exception, 'Not a proper mingle instance' unless match
        @mingle_version = match[1].gsub('_','.').to_f
      end

      private
      def mingle_about_page
        http             = Net::HTTP.new(@host_uri.host, @host_uri.port)
        http.use_ssl     = true if @host_uri.is_a?(URI::HTTPS)
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE if http.use_ssl
        http.get('/about').body
      end
    end
  end # class API
end