class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:github]

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_create do |user|
      user[:provider] = auth.provider
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.username = auth.info.nickname   # assuming the user model has a name
      user.token = auth.credentials.token  # used for octokit.rb
    end
  end

  def client
    @client ||= Octokit::Client.new(:access_token => self.token)
  end
end
