require 'rails/test_help'

ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)

require 'rubygems'
require 'minitest/autorun'
require "minitest/pride"
require 'minitest/focus'
require 'action_controller/test_case'

require 'capybara/rails'
require 'mocha'
require 'webmock/minitest'

require "warden/github/rails/test_helpers"

require File.join("#{File.expand_path(File.dirname(__FILE__))}", "jobs", "index_test.rb")
require File.join("#{File.expand_path(File.dirname(__FILE__))}", "view_models", "pages_builds", "index_view.rb")
require File.join("#{File.expand_path(File.dirname(__FILE__))}", "view_models", "webhooks", "add_view.rb")

# Support files
Dir[File.join("#{File.expand_path(File.dirname(__FILE__))}", "support", "*.rb")].each do |file|
  require file
end

# Factories
Dir[File.join("#{File.expand_path(File.dirname(__FILE__))}", "factories", "*.rb")].each do |file|
  require file
end

DatabaseCleaner.strategy = :truncation

class MiniTest::Spec
  include ActiveSupport::Testing::SetupAndTeardown
  include Warden::GitHub::Rails::TestHelpers
  include MetaHelper
  include BackgroundJobs

  # allow connections to elasticsearch
  WebMock.disable_net_connect!(:allow => /branta_application/)

  def fixture(name, extension="json")
    File.read(Rails.root.join('test', 'fixtures', "#{name}.#{extension}"))
  end

  def json_fixture(name)
    ActiveSupport::JSON.decode(fixture(name))
  end

  def default_headers(event, remote_ip = "192.30.252.0/22")
    {
      'ACCEPT'                 => 'application/json' ,
      'CONTENT_TYPE'           => 'application/json',

      'REMOTE_ADDR'            => remote_ip,
      'HTTP_X_FORWARDED_FOR'   => remote_ip,

      'HTTP_X_GITHUB_EVENT'    => event,
      'HTTP_X_GITHUB_DELIVERY' => SecureRandom.uuid
    }
  end

  def octokit_version
    Gem.loaded_specs['octokit'].version
  end

  before :each do
    DatabaseCleaner.start
  end

  after :each do
    DatabaseCleaner.clean
  end

  def sign_in(user)
    login_as(user, scope: :user)
    visit('/')
  end

  def sign_out
    logout(:user)
  end
end


class ControllerSpec < MiniTest::Spec
  include Rails.application.routes.url_helpers
  include ActionController::TestCase::Behavior

  before do
    @routes = Rails.application.routes
  end
end

# Test subjects ending with 'Controller' are treated as functional tests
#   e.g. describe TestController do ...
MiniTest::Spec.register_spec_type( /Controller$/, ControllerSpec )

class AcceptanceSpec < MiniTest::Spec
  include Rails.application.routes.url_helpers
  include ActionController::TestCase::Behavior
  include Capybara::DSL
  include Warden::Test::Helpers
  Warden.test_mode!

  before do
    @routes = Rails.application.routes
  end

  after do
    Warden.test_reset!
  end

  def default_url_options
    Rails.configuration.action_mailer.default_url_options
  end
end

MiniTest::Spec.register_spec_type( /Integration/, AcceptanceSpec )
