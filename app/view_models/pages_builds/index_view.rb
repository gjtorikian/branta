module PagesBuilds
  class IndexView
    attr_reader :pages_builds, :user_pages_builds

    def initialize
    end

    def empty_for_user?(user)
      repo_ids = Repository.where(:owner => user.login).pluck(:id)
      return true if repo_ids.empty?
      @user_pages_builds = repo_ids.map do |repo_id|
        PagesBuild.where(:repository_id => repo_id).limit(50)
      end
      @user_pages_builds.empty?
    end
  end
end
