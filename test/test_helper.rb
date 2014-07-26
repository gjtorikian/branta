require 'rails/test_help'

ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)

require 'rubygems'
gem 'minitest'
require "minitest/pride"
require 'minitest/autorun'
require 'minitest/focus'
require 'action_controller/test_case'

require 'miniskirt'
require 'capybara/rails'
require 'mocha'

# Support files
Dir["#{File.expand_path(File.dirname(__FILE__))}/support/*.rb"].each do |file|
  require file
end


class MiniTest::Spec
  include ActiveSupport::Testing::SetupAndTeardown

  # alias :method_name :__name__ if defined? :__name__
end


class ControllerSpec < MiniTest::Spec
  include Rails.application.routes.url_helpers
  include ActionController::TestCase::Behavior
  include Devise::TestHelpers

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

  before do
    @routes = Rails.application.routes
  end
end

# Test subjects ending with 'Integration' are treated as acceptance/integration tests
#   e.g. describe 'Test system Integration' do ...
MiniTest::Spec.register_spec_type( /Integration$/, AcceptanceSpec )
