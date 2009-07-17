module Mingle4r
  class MingleClient
    attr_accessor :site, :user, :password, :proj_id

    def initialize(site, user, password, proj_id = nil)
      # set project options
      @site = Project.site = site
      @user = Project.user = user
      @password = Project.password = password

      # set property definitions options
      prop_site = File.join(site, "projects/#{proj_id}")
      PropertyDefinition.site = prop_site
      PropertyDefinition.user = user
      PropertyDefinition.password = password
      
      @proj_id = proj_id
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
  end
end