class AppsController < ApplicationController
  respond_to :json

  def pages_builds
    @pages_builds = app.recent_pages_builds
  end

end
