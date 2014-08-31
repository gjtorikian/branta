require 'test_helper'

describe Webhooks::AddView do
  include Capybara::DSL

  before do
    @user = Warden::GitHub::Rails::TestHelpers::MockUser.new(:login => "someperson")
    sign_in @user
    @user_with_repos = JSON.parse fixture("user_with_repos")
    @user_without_repos = []
  end

  def stub_gh_repo_request(json)
    stub_request(:get, "https://api.github.com/user/repos?per_page=100").
      with(:headers => {'Accept'=>'application/vnd.github.v3+json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>"Octokit Ruby Gem #{octokit_version}"}).
      to_return(:status => 200, :body => json, :headers => {})
  end

  it 'should list Repositories for users with them' do
    stub_gh_repo_request(@user_with_repos)

    visit "/manage_webhook"

    assert_selector 'table'
    page.must_have_selector('button.add-hook-button', count: 2)
    # note: 3 repos, but just two buttons, because on repo has `admin:false`
    assert @user_with_repos.length, 3
  end

  it 'should list some helpful text for users with no repositories' do
    stub_gh_repo_request @user_without_repos

    visit "/manage_webhook"

    Repository.any_instance.stubs(:pages_repos).returns(@user_without_repos)

    page.must_have_content 'You have no repositories'
  end
end
