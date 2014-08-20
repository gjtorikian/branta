require 'test_helper'

describe Branta::ApiClient do
  setup do
    ENV['GITHUB_BRANTA_CLIENT_ID']     = 'id'
    ENV['GITHUB_BRANTA_CLIENT_SECRET'] = 'secret'
  end

  describe "#oauth_client_api" do
    it "#oauth_client_api uses #github_client_id and #github_client_secret" do

      Branta::ApiClient.github_client_id.must_equal "id"
      Branta::ApiClient.github_client_secret.must_equal "secret"
    end
  end

  teardown do
    ENV.delete('GITHUB_BRANTA_CLIENT_ID')
    ENV.delete('GITHUB_BRANTA_CLIENT_SECRET')
  end
end
