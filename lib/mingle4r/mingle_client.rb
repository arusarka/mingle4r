module Mingle4r
  class MingleClient
    attr_reader :site, :user, :password, :proj_id
    
    def initialize(site, user, password, proj_id = nil)
      @site = site.to_s
      @user = user
      @password = password
      @proj_id = proj_id
      set_resource_attributes()
    end
    
    def site=(site)
      if site != self.site
        @site = site
        uri = URI.parse(site)
        @user = URI.decode(uri.user) if(uri.user)
        @password = URI.decode(uri.password) if(uri.password)
        set_resource_attributes()
      end
      @site
    end

    def user=(user)
      if user != self.user
        @user = user
        set_resource_attributes()
      end
      @user
    end

    def password=(password)
      if password != self.password
        @password = password
        set_resource_attributes()
      end
      @password
    end
    
    def proj_id=(proj_id)
      if proj_id != @proj_id
        @proj_id = proj_id
        set_resource_attributes()
      end
      @proj_id
    end
    
    def valid_credentials?
      API::Project.site = base_url
      API::Project.user = user
      API::Project.password = password
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

    def users
      API::User.find(:all)
    end
    
    private
    def set_resource_attributes
      set_attributes(API::Project)
      set_attributes(API::User)
    end
    
    def set_attributes(klass)
      klass.site = base_url
      klass.user = @user
      klass.password = @password
    end
    
    def base_url
      File.join(@site.to_s, '/api/v2/')
    end
  end
end

# alias for the lazy ones
MingleClient = Mingle4r::MingleClient