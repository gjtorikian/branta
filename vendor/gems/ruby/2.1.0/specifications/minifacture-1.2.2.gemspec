# -*- encoding: utf-8 -*-
# stub: minifacture 1.2.2 ruby .

Gem::Specification.new do |s|
  s.name = "minifacture"
  s.version = "1.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["."]
  s.authors = ["Stephen Celis"]
  s.date = "2014-04-06"
  s.description = "Test::Unit begot MiniTest; factory_girl begets Minifacture."
  s.email = "stephen@stephencelis.com"
  s.homepage = "http://github.com/stephencelis/minifacture"
  s.licenses = ["MIT"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.7")
  s.rubygems_version = "2.2.2"
  s.summary = "factory_girl for minitest."

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, [">= 2.2"])
      s.add_development_dependency(%q<rake>, [">= 10.0.0", "~> 10.0"])
      s.add_development_dependency(%q<i18n>, [">= 0.6.0", "~> 0.6"])
    else
      s.add_dependency(%q<activesupport>, [">= 2.2"])
      s.add_dependency(%q<rake>, [">= 10.0.0", "~> 10.0"])
      s.add_dependency(%q<i18n>, [">= 0.6.0", "~> 0.6"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 2.2"])
    s.add_dependency(%q<rake>, [">= 10.0.0", "~> 10.0"])
    s.add_dependency(%q<i18n>, [">= 0.6.0", "~> 0.6"])
  end
end
