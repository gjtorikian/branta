require 'apps/pages_builds_view'

module PagesBuilds
  class IndexView < Apps::PagesBuildsView

    def initialize(pages_builds)
      super(pages_builds)
      @app = app
    end

  end
end
