require 'rails/test_help'

ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)

require 'rubygems'
gem 'minitest'
require "minitest/pride"
require 'minitest/autorun'
require 'minitest/focus'
require 'action_controller/test_case'

require 'capybara/rails'
require 'mocha'
require 'webmock/minitest'

# Support files
Dir["#{File.expand_path(File.dirname(__FILE__))}/support/*.rb"].each do |file|
  require file
end

# Factoris
Dir["#{File.expand_path(File.dirname(__FILE__))}/factories/*.rb"].each do |file|
  require file
end

DatabaseCleaner.strategy = :truncation

class MiniTest::Spec
  include ActiveSupport::Testing::SetupAndTeardown

  WebMock.disable_net_connect!(allow_localhost: true)

  def fixture(name, extension="json")
    File.read(Rails.root.join('test', 'fixtures', "#{name}.#{extension}"))
  end

  def json_fixture(name)
    ActiveSupport::JSON.decode(fixture(name))
  end

  before :each do
    DatabaseCleaner.start
  end

  after :each do
    DatabaseCleaner.clean
  end
end


class ControllerSpec < MiniTest::Spec
  include Rails.application.routes.url_helpers
  include ActionController::TestCase::Behavior
  include Devise::TestHelpers

  before do
    @routes = Rails.application.routes
  end

  def stub_gh_hook_creation(json)
    stub_request(:get, "https://api.github.com/repos/octocat/Page-World/hooks?per_page=100").
      with(:headers => {'Accept'=>'application/vnd.github.v3+json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'token secrets1', 'User-Agent'=>'Octokit Ruby Gem 3.2.0'}).
      to_return(:status => 200, :body => json, :headers => {})
  end

  def stub_gh_hook_deletion(json)
    stub_request(:get, "https://api.github.com/repos/octocat/Page-World/hooks?per_page=100").
      with(:headers => {'Accept'=>'application/vnd.github.v3+json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'token secrets1', 'User-Agent'=>'Octokit Ruby Gem 3.2.0'}).
      to_return(:status => 200, :body => json, :headers => {})
  end
end

# Test subjects ending with 'Controller' are treated as functional tests
#   e.g. describe TestController do ...
MiniTest::Spec.register_spec_type( /Controller$/, ControllerSpec )

class AcceptanceSpec < MiniTest::Spec
  include Rails.application.routes.url_helpers
  include Capybara::DSL
  include Warden::Test::Helpers
  Warden.test_mode!

  before do
    @routes = Rails.application.routes
  end

  after do
    Warden.test_reset!
  end

  def sign_in(user)
    login_as(user, scope: :user)
    visit('/')
  end

  def sign_out
    logout(:user)
  end

  def default_url_options
    Rails.configuration.action_mailer.default_url_options
  end

  def stub_gh_repo_request(json)
    stub_request(:get, "https://api.github.com/user/repos?per_page=100").
      with(:headers => {'Accept'=>'application/vnd.github.v3+json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'token secrets1', 'User-Agent'=>'Octokit Ruby Gem 3.2.0'}).
      to_return(:status => 200, :body => json, :headers => {})
  end

  def stub_gh_hook_request(json)
    stub_request(:get, "https://api.github.com/repos/octocat/Hello-World/hooks?per_page=100").
      with(:headers => {'Accept'=>'application/vnd.github.v3+json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'token secrets1', 'User-Agent'=>'Octokit Ruby Gem 3.2.0'}).
      to_return(:status => 200, :body => "", :headers => {})

    stub_request(:get, "https://api.github.com/repos/octocat/Hola-World/hooks?per_page=100").
      with(:headers => {'Accept'=>'application/vnd.github.v3+json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'token secrets1', 'User-Agent'=>'Octokit Ruby Gem 3.2.0'}).
      to_return(:status => 200, :body => "", :headers => {})

    stub_request(:get, "https://api.github.com/repos/octocat/Page-World/hooks?per_page=100").
      with(:headers => {'Accept'=>'application/vnd.github.v3+json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'token secrets1', 'User-Agent'=>'Octokit Ruby Gem 3.2.0'}).
      to_return(:status => 200, :body => json, :headers => {})
  end
end

MiniTest::Spec.register_spec_type( /Integration$/, AcceptanceSpec )
