class User < ActiveRecord::Base
  validates :github_id, :uniqueness => true

  def client
    @client ||= Octokit::Client.new(:access_token => self.token)
  end
end
