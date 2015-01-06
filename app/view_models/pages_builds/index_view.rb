module PagesBuilds
  class IndexView
    attr_reader :pages_builds, :user_pages_builds, :org_pages_builds

    def initialize
    end

    def empty_for_user?(user)
      repo_ids = Repository.where(:owner => user.login).pluck(:repo_id)
      return true if repo_ids.empty?
      @user_pages_builds = repo_ids.map do |repo_id|
        PagesBuild.where(:repo_id => repo_id.to_i).limit(50)
      end
      @user_pages_builds.empty?
    end

    def empty_for_org?
      @org_pages_builds = PagesBuild.where(:status => "built").limit(50)
      @org_pages_builds.empty?
    end
  end
end
