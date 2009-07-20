module Mingle4r
  class MingleClient
    attr_reader :site, :user, :password, :proj_id

    def initialize(site, user, password, proj_id = nil)
      @site = site
      @user = user
      @password = password
      @proj_id = proj_id
      set_resource_attributes      
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
      Project.site = site
      Project.user = user
      Project.password = password
      begin
        Project.find(:all)
        true
      rescue Exception => e
        e.message
      end
    end

    def project
      raise 'proj_id attribute not set' unless @proj_id
      @project = Mingle4r::Project.find(@proj_id) unless(@project && (@proj_id == @project.identifier))
      @project
    end
    
    def projects
      Mingle4r::Project.find(:all)
    end

    def cards
      raise 'proj_id attribute not set' unless @proj_id
      @project = Mingle4r::Project.find(@proj_id) unless(@project && (@proj_id == @project.identifier))
      @project.cards
    end
    
    private
    def set_resource_attributes
      set_project_attributes
      set_property_definition_attributes
    end
    
    def set_project_attributes
      Project.site = @site
      Project.user = @user
      Project.password = @password
    end
    
    def set_property_definition_attributes
      raise 'Project Id (proj_id attribute) not given.' unless @proj_id
      properties_site = File.join(@site.to_s, "projects/#{@proj_id}")
      PropertyDefinition.site = properties_site
      PropertyDefinition.user = @user
      PropertyDefinition.password = @password
    end
  end
end