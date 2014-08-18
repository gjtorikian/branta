class SessionsController < ApplicationController
  def destroy
    session.destroy
    redirect_to "/"
  end

  def create
    # warden-github-rails does the work. This exists just to give us a place
    # to link to to create users.
    render :text => "<html><body><h1>Welcome!</h1></body></html>"
  end
end
