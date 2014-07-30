# -*- encoding: utf-8 -*-
# stub: capybara_minitest_spec 1.0.3 ruby lib

Gem::Specification.new do |s|
  s.name = "capybara_minitest_spec"
  s.version = "1.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Jared Ning"]
  s.date = "2014-07-28"
  s.description = "Use Capybara matchers with MiniTest. Specifically, it defines MiniTest::Spec expectations like page.must_have_content('content')."
  s.email = ["jared@redningja.com"]
  s.homepage = "https://github.com/ordinaryzelig/capybara_minitest_spec"
  s.licenses = ["MIT"]
  s.rubyforge_project = "capybara_minitest_spec"
  s.rubygems_version = "2.2.2"
  s.summary = "Capybara + MiniTest::Spec"

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<capybara>, [">= 2"])
      s.add_runtime_dependency(%q<minitest>, [">= 2"])
      s.add_development_dependency(%q<awesome_print>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<sinatra>, [">= 0.9.4"])
    else
      s.add_dependency(%q<capybara>, [">= 2"])
      s.add_dependency(%q<minitest>, [">= 2"])
      s.add_dependency(%q<awesome_print>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<sinatra>, [">= 0.9.4"])
    end
  else
    s.add_dependency(%q<capybara>, [">= 2"])
    s.add_dependency(%q<minitest>, [">= 2"])
    s.add_dependency(%q<awesome_print>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<sinatra>, [">= 0.9.4"])
  end
end
