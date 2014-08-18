require 'test_helper'

describe ApiClient do
  class ExampleClass
    extend ApiClient
  end

  describe "#oauth_client_api" do
    it "#oauth_client_api uses #github_client_id and #github_client_secret" do
      ENV['GITHUB_CLIENT_ID']     = 'id'
      ENV['GITHUB_CLIENT_SECRET'] = 'secret'

    stub_request(:get, "https://api.github.com/meta?client_id=id&client_secret=secret").
      with(:headers => {'Accept'=>'application/vnd.github.v3+json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>"Octokit Ruby Gem #{octokit_version}"}).
      to_return(:status => 200, :body => "ok", :headers => {})

      ExampleClass.oauth_client_api.meta.must_equal "ok"
    end
  end
end
