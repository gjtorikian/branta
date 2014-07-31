require 'test_helper'

describe 'Login Integration' do
  setup do
    @user = Factory.create :user
    @user_with_repos = json_fixture("user_with_repos")
    @user_without_repos = json_fixture("user_without_repos")
    @user_without_pages_repos = json_fixture("user_without_pages_repos")

    @mock = MiniTest::Mock.new
  end

  describe "logging in" do
    it 'should list Pages repositories for users with them' do
      visit "/"

      @mock.expect(:pages_repos, @user_with_repos)
      @mock.expect(:has_hook_to_granta?, nil, [""]) # octocat/Hello-World
      @mock.expect(:has_hook_to_granta?, nil, [""]) # octocat/Hola-World
      @mock.expect(:has_hook_to_granta?, [], [""]) # octocat/Page-World

      stub_gh_repo_request @user_with_repos
      stub_gh_hook_request @user_repository_hooks

      PagesRepository.stub(:new, @mock) do
        sign_in @user
      end
      assert @mock.verify

      assert_selector 'table'
      page.must_have_selector('span.octicon-zap', count: 2)
      page.must_have_selector('span.octicon-x', count: 3) # two for the missing, one for the "take it off"
    end

    it 'should list some helpful text for users with no repositories' do
      visit "/"

      stub_gh_repo_request @user_without_repos

      PagesRepository.stub(:new, @mock) do
        sign_in @user
      end
      assert @mock.verify

      page.must_have_content 'You have no repositories'
    end

    it 'should list some helpful text for users with no Pages repositories' do
      visit "/"

      @mock.expect(:pages_repos, [])

      stub_gh_repo_request @user_without_pages_repos

      PagesRepository.stub(:new, @mock) do
        sign_in @user
      end
      assert @mock.verify

      page.must_have_content 'but none of them have GitHub Pages'
    end
  end
end
