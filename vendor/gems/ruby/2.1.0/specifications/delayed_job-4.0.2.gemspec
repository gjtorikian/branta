# -*- encoding: utf-8 -*-
# stub: delayed_job 4.0.2 ruby lib

Gem::Specification.new do |s|
  s.name = "delayed_job"
  s.version = "4.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Brandon Keepers", "Brian Ryckbost", "Chris Gaffney", "David Genord II", "Erik Michaels-Ober", "Matt Griffin", "Steve Richert", "Tobias L\u{fc}tke"]
  s.date = "2014-06-24"
  s.description = "Delayed_job (or DJ) encapsulates the common pattern of asynchronously executing longer tasks in the background. It is a direct extraction from Shopify where the job table is responsible for a multitude of core tasks."
  s.email = ["brian@collectiveidea.com"]
  s.homepage = "http://github.com/collectiveidea/delayed_job"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.2.2"
  s.summary = "Database-backed asynchronous priority queue system -- Extracted from Shopify"

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, ["< 4.2", ">= 3.0"])
    else
      s.add_dependency(%q<activesupport>, ["< 4.2", ">= 3.0"])
    end
  else
    s.add_dependency(%q<activesupport>, ["< 4.2", ">= 3.0"])
  end
end
