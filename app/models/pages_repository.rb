require 'uri'

class PagesRepository < ActiveRecord::Base
  validates_presence_of :name_with_owner

  def self.pages_repos(payload)
    @pages_repos ||= payload.select { |repo| repo["name"] =~ /page/i }
  end

  def self.has_hook_to_granta?(repo_name)
    !PagesRepository.find_by_name_with_owner(repo_name).nil?
  end
end
