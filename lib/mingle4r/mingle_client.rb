module Mingle4r
  class MingleClient
    attr_reader :site, :user, :password, :proj_id
    
    def initialize(site, user, password, proj_id = nil)
      @site = site.to_s
      @user = user
      @password = password
      @proj_id = proj_id
      setup_project_class
    end
    
    def site=(site)
      @site = site
      user, password = decode_uri(site)
      @user = user if user
      @password = password if password
      setup_project_class
      @site
    end

    def user=(user)
      @user = user
      setup_project_class
      @user
    end

    def password=(password)
      @password = password
      setup_project_class
      @password
    end
    
    def proj_id=(proj_id)
      @proj_id = proj_id
      setup_project_class
      @proj_id
    end
    
    def valid_credentials?
      setup_project_class
      begin
        API::Project.find(:all)
        true
      rescue Exception => e
        false
      end
    end

    def project
      raise 'proj_id attribute not set' unless @proj_id
      @project = API::Project.find(@proj_id) unless(@project && (@proj_id == @project.identifier))
      @project
    end
    
    def projects
      API::Project.find(:all)
    end

    def method_missing(meth_id, *args, &block)
      project.send(meth_id, *args, &block)
    end
    
    private
    def setup_project_class
      klass = API::Project
      klass.site = base_url
      klass.user = @user
      klass.password = @password
    end
    
    def base_url
      File.join(@site.to_s, '/api/v2/')
    end
    
    def decode_uri(site)
      uri = URI.parse(site)
      [uri.user, uri.password]
    end
  end
end

# alias for the lazy ones
MingleClient = Mingle4r::MingleClient