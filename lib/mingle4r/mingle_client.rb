module Mingle4r
  class MingleClient
    attr_accessor :site, :user, :password, :proj_id

    def initialize(site, user, password, proj_id)
      @site = Project.site = site
      @user = Project.user = user
      @password = Project.password = password
      @proj_id = proj_id
    end

    def valid_credentials?
      Project.site = site
      Project.user = user
      Project.password = password
      begin
        Project.find(:all)
        true
      rescue Exception
        false
      end
    end

    def project
      raise Exception 'proj_id attribute not set' unless proj_id
      @project = Mingle4r::Project.find(proj_id)
    end

    def cards
      raise Exception 'proj_id attribute not set' unless proj_id
      @project = Mingle4r::Project.find(proj_id) unless(@project && (proj_id == @project.identifier))
      @project.cards
    end
  end
end