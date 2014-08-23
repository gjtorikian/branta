class SessionsController < ApplicationController
  def create
    github_authenticate!
    @user = User.for(github_user)
    redirect_to root_url
  end

  def destroy
    session.destroy
    redirect_to root_url
  end
end
