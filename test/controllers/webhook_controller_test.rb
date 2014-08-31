require 'test_helper'

describe WebhookController do
  setup do
    user = Warden::GitHub::Rails::TestHelpers::MockUser.new(:login => "someperson")
    WebhookController.any_instance.stubs(:github_user).returns(user)
  end

  it "should create new Repository when hook is added" do
    assert_equal Repository.all.count, 0

    create_hook = JSON.parse fixture("create_hook")

    stub_request(:post, "https://api.github.com/repos/gjtorikian/branta/hooks").
      with(:body => "{\"name\":\"web\",\"config\":{\"url\":\"http://test.host/post_receive\",\"content_type\":\"json\"},\"events\":[\"page_build\"],\"active\":true}",
           :headers => {'Accept'=>'application/vnd.github.v3+json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>"Octokit Ruby Gem #{octokit_version}"}).
      to_return(:status => 200, :body => create_hook.symbolize_keys, :headers => {})

    post :create, name: "gjtorikian/branta", :format => 'json'

    assert_equal Repository.all.count, 1

    repo = Repository.first
    assert_equal repo.hook_id, create_hook["id"]
  end

  it "should remove PagesRepository when hook is removed" do
    repository = Factory.create :repository
    assert_equal Repository.all.count, 1

    stub_request(:delete, "https://api.github.com/repos/#{repository.name_with_owner}/hooks/#{repository.hook_id}").
      with(:body => "{}",
           :headers => {'Accept'=>'application/vnd.github.v3+json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>"Octokit Ruby Gem #{octokit_version}"}).
      to_return(:status => 200, :body => "", :headers => {})

    delete :delete, name: repository.name_with_owner, :format => 'json'

    assert_equal Repository.all.count, 0
  end
end
