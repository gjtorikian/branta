module MetaHelper
  def stub_meta

    ENV['GITHUB_CLIENT_ID']     = 'id'
    ENV['GITHUB_CLIENT_SECRET'] = 'secret'

    body = JSON.load(fixture("meta"))

    body_hash = {:hooks => body["hooks"]}

    stub_request(:get, "https://api.github.com/meta?client_id=%3Cunknown-client-id%3E&client_secret=%3Cunknown-client-secret%3E").
      with(:headers => {'Accept'=>'application/vnd.github.v3+json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>"Octokit Ruby Gem #{octokit_version}"}).
      to_return(:status => 200, :body => OpenStruct.new(body_hash) )
  end
end
