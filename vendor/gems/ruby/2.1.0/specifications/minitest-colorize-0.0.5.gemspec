# -*- encoding: utf-8 -*-
# stub: minitest-colorize 0.0.5 ruby lib

Gem::Specification.new do |s|
  s.name = "minitest-colorize"
  s.version = "0.0.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Gabriel Sobrinho"]
  s.date = "2013-02-19"
  s.description = "Colorize MiniTest output and show failing tests instantly"
  s.email = ["gabriel.sobrinho@gmail.com"]
  s.homepage = "https://github.com/sobrinho/minitest-colorize"
  s.rubygems_version = "2.2.2"
  s.summary = "Colorize MiniTest output and show failing tests instantly"

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<minitest>, [">= 2.0"])
      s.add_development_dependency(%q<rake>, [">= 0.8.7"])
      s.add_development_dependency(%q<mocha>, [">= 0.9.12"])
    else
      s.add_dependency(%q<minitest>, [">= 2.0"])
      s.add_dependency(%q<rake>, [">= 0.8.7"])
      s.add_dependency(%q<mocha>, [">= 0.9.12"])
    end
  else
    s.add_dependency(%q<minitest>, [">= 2.0"])
    s.add_dependency(%q<rake>, [">= 0.8.7"])
    s.add_dependency(%q<mocha>, [">= 0.9.12"])
  end
end
