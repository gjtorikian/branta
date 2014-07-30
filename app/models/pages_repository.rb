class PagesRepository
  def initialize(payload)
    @repos = payload
  end

  def pages_repos
    @pages_repos ||= @repos.select { |repo| repo["name"] =~ /page/i }
  end

  def has_hook_to_granta?(client, repo_nwo)
    !client.hooks(repo_nwo).select { |hook| hook["config"]["url"] =~ /granta|0\.0\.0\.0/ }.empty?
  end
end
