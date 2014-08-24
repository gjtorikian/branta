require "test_helper"

describe "Routes Integration Test" do
  before do
    sign_out
    @user = Warden::GitHub::Rails::TestHelpers::MockUser.new(:login => "someperson")
    ENV.delete('GITHUB_BRANTA_ORG_NAME')
  end

  it "lets anyone go to the home page" do
    visit "/"
    page.body.must_match /hey./
  end

  it "lets logged in users get to an empty page" do
    sign_in @user
    page.body.must_match /No GitHub Pages sites have been indexed for you/
  end

  describe "for orgs" do
    before do
      @githubber = Warden::GitHub::Rails::TestHelpers::MockUser.new(:login => "gjtorikian")
      @githubber.stub_membership(org: 'github')
      ENV['GITHUB_BRANTA_ORG_NAME'] = 'github'
    end

    it 'shows nothing for nobodies' do
      visit "/"
      page.body.must_match /nope./
    end

    it 'shows nothing for logged in nobodies' do
      skip "Works in real life, but not in test"
      sign_in @user
      visit "/"
      page.body.must_match /nope./
    end

    it 'shows something for logged in somebodies' do
      sign_in @githubber
      visit "/"
      page.body.must_match /No GitHub Pages sites have been indexed for y'all/
    end
  end
end
