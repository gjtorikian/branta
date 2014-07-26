# -*- encoding: utf-8 -*-
# stub: dotenv-rails 0.11.1 ruby lib

Gem::Specification.new do |s|
  s.name = "dotenv-rails"
  s.version = "0.11.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Brandon Keepers"]
  s.date = "2014-04-22"
  s.description = "Autoload dotenv in Rails."
  s.email = ["brandon@opensoul.org"]
  s.homepage = "https://github.com/bkeepers/dotenv"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.2.2"
  s.summary = "Autoload dotenv in Rails."

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<dotenv>, ["= 0.11.1"])
    else
      s.add_dependency(%q<dotenv>, ["= 0.11.1"])
    end
  else
    s.add_dependency(%q<dotenv>, ["= 0.11.1"])
  end
end
