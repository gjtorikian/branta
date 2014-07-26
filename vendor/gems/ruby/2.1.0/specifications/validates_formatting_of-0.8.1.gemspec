# -*- encoding: utf-8 -*-
# stub: validates_formatting_of 0.8.1 ruby lib

Gem::Specification.new do |s|
  s.name = "validates_formatting_of"
  s.version = "0.8.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Matt Bridges"]
  s.date = "2013-10-01"
  s.description = "Common Rails validations wrapped in a gem."
  s.email = ["mbridges.91@gmail.com"]
  s.homepage = "https://github.com/mattdbridges/validates_formatting_of"
  s.rubygems_version = "2.2.2"
  s.summary = "Adds several convenient methods to validate things such as emails, urls, and phone numbers in a Rails application"

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activemodel>, ["~> 4.0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<simplecov>, [">= 0"])
    else
      s.add_dependency(%q<activemodel>, ["~> 4.0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<simplecov>, [">= 0"])
    end
  else
    s.add_dependency(%q<activemodel>, ["~> 4.0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<simplecov>, [">= 0"])
  end
end
