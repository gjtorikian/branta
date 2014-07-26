# -*- encoding: utf-8 -*-
# stub: bootstrap-sass-extras 0.0.6 ruby lib

Gem::Specification.new do |s|
  s.name = "bootstrap-sass-extras"
  s.version = "0.0.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["doabit"]
  s.date = "2014-04-12"
  s.description = "bootstrap-sass extras."
  s.email = ["doinsist@gmail.com"]
  s.homepage = "https://github.com/doabit/bootstrap-sass-extras"
  s.rubygems_version = "2.2.2"
  s.summary = "bootstrap-sass extras."

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, [">= 3.1.0"])
      s.add_development_dependency(%q<rspec-rails>, [">= 0"])
      s.add_development_dependency(%q<sqlite3>, [">= 0"])
    else
      s.add_dependency(%q<rails>, [">= 3.1.0"])
      s.add_dependency(%q<rspec-rails>, [">= 0"])
      s.add_dependency(%q<sqlite3>, [">= 0"])
    end
  else
    s.add_dependency(%q<rails>, [">= 3.1.0"])
    s.add_dependency(%q<rspec-rails>, [">= 0"])
    s.add_dependency(%q<sqlite3>, [">= 0"])
  end
end
