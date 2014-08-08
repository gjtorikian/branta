require 'test_helper'

describe 'Login Integration' do
  setup do
    @user = Factory.create :user
    @user_with_repos = json_fixture("user_with_repos")
    @user_without_repos = json_fixture("user_without_repos")
    @user_without_pages_repos = json_fixture("user_without_pages_repos")
  end

  describe "logging in successfully" do
    before do
      stub_gh_repo_request @user_with_repos
      stub_gh_hook_request @user_repository_hooks
    end

    it 'should list Pages repositories for users with them' do
      visit "/"
      sign_in @user

      assert_selector 'table'
      page.must_have_selector('button.add-hook-button', count: 1)
      page.must_have_selector('button.remove-hook-button', count: 0)
    end
  end

  describe 'other kinds of logging in' do
    it 'should list some helpful text for users with no repositories' do
      stub_gh_repo_request @user_without_repos

      visit "/"
      sign_in @user

      PagesRepository.any_instance.stubs(:pages_repos).returns(@user_without_repos)

      page.must_have_content 'You have no repositories'
    end

    it 'should list some helpful text for users with no Pages repositories' do
      stub_gh_repo_request @user_without_pages_repos

      visit "/"
      sign_in @user

      PagesRepository.any_instance.stubs(:pages_repos).returns(@user_without_pages_repos)

      page.must_have_content 'but none of them have GitHub Pages'
    end
  end
end
