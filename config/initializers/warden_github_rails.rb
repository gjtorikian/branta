require 'warden/github/rails'

Warden::GitHub::Rails.setup do |config|
  config.add_scope :user,  :client_id     => ENV['GITHUB_BRANTA_CLIENT_ID'],
                           :client_secret => ENV['GITHUB_BRANTA_CLIENT_SECRET'],
                           :scope         => ["user:email"]

  # config.add_team :employees, ENV['GITHUB_TEAM_ID'] || '696075'

  config.default_scope = :user
end
