# -*- encoding: utf-8 -*-
# stub: minitest-rails 2.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "minitest-rails"
  s.version = "2.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Mike Moore"]
  s.date = "2014-07-09"
  s.description = "Adds Minitest as the default testing library in Rails"
  s.email = ["mike@blowmage.com"]
  s.extra_rdoc_files = ["CHANGELOG.rdoc", "Manifest.txt", "README.rdoc"]
  s.files = ["CHANGELOG.rdoc", "Manifest.txt", "README.rdoc"]
  s.homepage = "http://blowmage.com/minitest-rails"
  s.licenses = ["MIT"]
  s.rdoc_options = ["--main", "README.rdoc"]
  s.rubygems_version = "2.2.2"
  s.summary = "Minitest integration for Rails"

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<minitest>, ["~> 5.4"])
      s.add_runtime_dependency(%q<railties>, ["~> 4.1"])
      s.add_development_dependency(%q<rdoc>, ["~> 4.0"])
      s.add_development_dependency(%q<fakefs>, ["= 0.4.3"])
      s.add_development_dependency(%q<hoe>, ["~> 3.12"])
    else
      s.add_dependency(%q<minitest>, ["~> 5.4"])
      s.add_dependency(%q<railties>, ["~> 4.1"])
      s.add_dependency(%q<rdoc>, ["~> 4.0"])
      s.add_dependency(%q<fakefs>, ["= 0.4.3"])
      s.add_dependency(%q<hoe>, ["~> 3.12"])
    end
  else
    s.add_dependency(%q<minitest>, ["~> 5.4"])
    s.add_dependency(%q<railties>, ["~> 4.1"])
    s.add_dependency(%q<rdoc>, ["~> 4.0"])
    s.add_dependency(%q<fakefs>, ["= 0.4.3"])
    s.add_dependency(%q<hoe>, ["~> 3.12"])
  end
end
