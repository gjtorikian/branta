require 'test_helper'

describe 'Login Integration' do
  setup do
    @user = Factory.create :user
    @user_with_repos = json_fixture("user_with_repos")
    @user_without_repos = json_fixture("user_without_repos")
    @user_without_pages_repos = json_fixture("user_without_pages_repos")

    @mock = MiniTest::Mock.new
  end

  it 'should list Pages repositories for users with them' do
    visit "/"

    @mock.expect(:pages_repos, @user_with_repos)

    stub_request(:get, "https://api.github.com/user/repos?per_page=100").
      with(:headers => {'Accept'=>'application/vnd.github.v3+json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'token secrets1', 'User-Agent'=>'Octokit Ruby Gem 3.2.0'}).
      to_return(:status => 200, :body => @user_with_repos, :headers => {})

    PagesRepository.stub(:new, @mock) do
      sign_in @user
    end
    assert @mock.verify

    assert_selector 'table'
  end

  it 'should list some helpful text for users with no repositories' do
    visit "/"

    stub_request(:get, "https://api.github.com/user/repos?per_page=100").
      with(:headers => {'Accept'=>'application/vnd.github.v3+json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'token secrets1', 'User-Agent'=>'Octokit Ruby Gem 3.2.0'}).
      to_return(:status => 200, :body => @user_without_repos, :headers => {})

    PagesRepository.stub(:new, @mock) do
      sign_in @user
    end
    assert @mock.verify

    page.must_have_content 'You have no repositories'
  end

  it 'should list some helpful text for users with no Pages repositories' do
    visit "/"

    @mock.expect(:pages_repos, [])

    stub_request(:get, "https://api.github.com/user/repos?per_page=100").
      with(:headers => {'Accept'=>'application/vnd.github.v3+json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'token secrets1', 'User-Agent'=>'Octokit Ruby Gem 3.2.0'}).
      to_return(:status => 200, :body => @user_without_pages_repos, :headers => {})

    PagesRepository.stub(:new, @mock) do
      sign_in @user
    end
    assert @mock.verify

    page.must_have_content 'but none of them have GitHub Pages'
  end
end
