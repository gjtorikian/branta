class User < ActiveRecord::Base
  validates_uniqueness_of :github_id, :login

  def client
    @client ||= Octokit::Client.new(:access_token => self.token)
  end

  def self.for(github_user)
    user = find_or_initialize_by(github_id: github_user.id)
    user.login = github_user.login
    user.email = github_user.email
    user.token = github_user.token

    user.save
    user
  end
end
