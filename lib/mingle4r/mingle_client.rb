module Mingle4r
  class MingleClient
    attr_reader :site, :user, :password, :proj_id
    
    def initialize(site, user, password, proj_id = nil)
      @site = site
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
      project_class = @api.project_class
      project_class.site = @api.base_url
      project_class.user = user
      project_class.password = password
      begin
        project_class.find(:all)
        true
      rescue Exception => e
        e.message
      end
    end

    def project
      raise 'proj_id attribute not set' unless @proj_id
      @project = @api.project_class.find(@proj_id) unless(@project && (@proj_id == @project.identifier))
      @project
    end
    
    def projects
      @api.project_class.find(:all)
    end

    def users
      @api.user_class.find(:all)
    end
    
    private
    def set_resource_attributes
      @api = API.create(@site)
      set_attributes(@api.project_class)
      set_attributes(@api.user_class)
    end
    
    def set_attributes(klass)
      klass.site = @api.base_url
      klass.user = @user
      klass.password = @password
    end
  end
end

# alias for the lazy ones
MingleClient = Mingle4r::MingleClient