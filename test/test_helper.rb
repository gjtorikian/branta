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

require "warden/github/rails/test_helpers"

# Support files
Dir["#{File.expand_path(File.dirname(__FILE__))}/support/*.rb"].each do |file|
  require file
end

# Factories
Dir["#{File.expand_path(File.dirname(__FILE__))}/factories/*.rb"].each do |file|
  require file
end

DatabaseCleaner.strategy = :truncation

class MiniTest::Spec
  include ActiveSupport::Testing::SetupAndTeardown
  include MetaHelper
  include WardenHelpers

  WebMock.disable_net_connect!(allow_localhost: true)

  def fixture(name, extension="json")
    File.read(Rails.root.join('test', 'fixtures', "#{name}.#{extension}"))
  end

  def json_fixture(name)
    ActiveSupport::JSON.decode(fixture(name))
  end

  def default_headers(event, remote_ip = "192.30.252.41")
    {
      'ACCEPT'                 => 'application/json' ,
      'CONTENT_TYPE'           => 'application/json',

      'REMOTE_ADDR'            => remote_ip,
      'HTTP_X_FORWARDED_FOR'   => remote_ip,

      'HTTP_X_GITHUB_EVENT'    => event,
      'HTTP_X_GITHUB_DELIVERY' => SecureRandom.uuid
    }
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

  before do
    @routes = Rails.application.routes
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
end

MiniTest::Spec.register_spec_type( /Integration$/, AcceptanceSpec )
