class PagesRepository
  def initialize(payload)
    @repos = payload
  end

  def pages_repos
    @pages_repos ||= @repos.select { |repo| repo["name"] =~ /page/i }
  end
end
