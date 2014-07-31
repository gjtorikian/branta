require 'uri'

class PagesRepository
  def initialize(payload)
    @repos = payload
  end

  def pages_repos
    @pages_repos ||= @repos.select { |repo| repo["name"] =~ /page/i }
  end

  def has_hook_to_granta?(hooks)
    hooks.select do |hook|
      url = hook["config"]["url"]
      next if url.nil?
      uri = URI.parse(url)
      if Rails.env.production? || Rails.env.test?
        return uri.host == "www.branta.com"
      else
        return uri.host == "www.branta.com" || uri.host == "0.0.0.0"
      end
    end.present?
  end
end
