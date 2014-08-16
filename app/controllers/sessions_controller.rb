class SessionsController < ApplicationController
  def destroy
    session.destroy
    redirect_to "/"
  end

  def create
    # warden-github-rails does the work. This exists just to give us a place
    # to link to to create users.
    render :text => "<html><body><img src=/welcome.png></img></body></html>"
  end
end
