module Apps
  class PagesBuildsView
    attr_reader :app
    attr_reader :pages_builds

    def initialize(pages_builds, app = nil)
      @pages_builds = pages_builds
      @app = app
    end

    def total_pages_builds
      pages_builds.count
    end
  end
end
