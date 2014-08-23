class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def index
    @pages_builds = PagesBuild.limit(50).reverse_order
  end
end
