require "test_helper"

describe SearchController do
  setup do
    Branta::IndexManager.create_index(true)
    repos = []
    5.times do |i|
      hash = {
               :title => "item #{i} of five entries",
               :body => fixture("rubbish", "txt").strip,
               :path => "/path/#{i}/article",
               :repo => "gjtorikian/repo#{i}"
             }
      repos << "gjtorikian/repo#{i}"
      Page.create hash
    end
    @multiple_repo_qualifier = { :repo => repos.join(",") }
    Page.gateway.refresh_index!
  end

  # there seems to be some kind of timing issue on Travis, and the only fix is to
  # explicitly ask for the sort and order
  def make_request(q, opts = {})
    if ENV['IS_CI']
      opts[:sort] = opts[:sort] || "created_at"
      opts[:order] = opts[:order] || "asc"
    end

    get 'index', {:q => q, :page => opts[:page], :sort => opts[:sort], :order => opts[:order], :repo => opts[:repo]}
  end

  describe 'results in the body' do
    it 'can find results in the body' do
      make_request("administrate", @multiple_repo_qualifier)

      assert_response response.status, 200
      body = JSON.parse(response.body)
      body["total"].must_equal 5

      result = body["results"].first

      result["title"].must_equal "item 0 of five entries"
      result["path"].must_equal "/path/0/article"
      result["body"].must_match "<span class=\"search-term\">administrate</span>"
    end

    it 'can take singular words and match plural words in the body' do
      make_request("market", @multiple_repo_qualifier)

      assert_response response.status, 200
      body = JSON.parse(response.body)
      body["total"].must_equal 5

      result = body["results"].first
      result["body"].must_match "<span class=\"search-term\">markets</span>"
    end

    it 'can take plural words and match singular words in the body' do
      make_request("visualizes", @multiple_repo_qualifier)

      assert_response response.status, 200
      body = JSON.parse(response.body)
      body["total"].must_equal 5

      result = body["results"].first
      result["body"].must_match "<span class=\"search-term\">visualize</span>"
    end
  end

  describe 'results in the title' do
    it 'can find results in the title' do
      make_request("item", @multiple_repo_qualifier)

      assert_response response.status, 200
      body = JSON.parse(response.body)
      body["total"].must_equal 5

      result = body["results"].first

      result["title"].must_equal "<span class=\"search-term\">item</span> 0 of five entries"
      result["path"].must_equal "/path/0/article"
      result["body"].must_match "Collaboratively administrate empowered markets via plug-and-play networks. Dynamically procrastinate B2C users after installed base benefits. Dramatically visualize customer directed convergence without revolutionary ROI.…"
    end

    it 'can take singular words and match plural words in the title' do
      make_request("entry", @multiple_repo_qualifier)

      assert_response response.status, 200
      body = JSON.parse(response.body)
      body["total"].must_equal 5

      result = body["results"].first
      result["title"].must_match "item 0 of five <span class=\"search-term\">entries</span>"
    end

    it 'can take plural words and match singular words in the title' do
      make_request("items", @multiple_repo_qualifier)

      assert_response response.status, 200
      body = JSON.parse(response.body)
      body["total"].must_equal 5

      result = body["results"].first
      result["title"].must_match "<span class=\"search-term\">item</span> 0 of five entries"
    end
  end

  describe 'pagination' do
    setup do
      ENV['BRANTA_PER_PAGE_COUNT'] = '1'
    end

    teardown do
      ENV['BRANTA_PER_PAGE_COUNT'] = ''
    end

    it 'limits the results' do
      make_request("administrate", @multiple_repo_qualifier)

      assert_response response.status, 200
      body = JSON.parse(response.body)
      body["total"].must_equal 5
      body["results"].length.must_equal 1
    end

    it 'can get a page of results' do
      make_request("administrate", @multiple_repo_qualifier.merge({:page => 4}))

      assert_response response.status, 200
      body = JSON.parse(response.body)
      body["total"].must_equal 5

      result = body["results"].first
      result["title"].must_equal "item 3 of five entries"
    end
  end

  describe 'sorting' do
    it 'properly sorts the results' do
      make_request("administrate", @multiple_repo_qualifier.merge({:order => "desc", :sort => "updated_at"}))

      assert_response response.status, 200
      body = JSON.parse(response.body)
      body["total"].must_equal 5
      body["results"].length.must_equal 5

      result = body["results"].first
      result["title"].must_equal "item 4 of five entries"
    end
  end

  describe 'repo scoping' do
    it 'properly scopes to a repo' do
      make_request("entry", {:repo => "gjtorikian/repo2"})

      assert_response response.status, 200
      body = JSON.parse(response.body)
      body["total"].must_equal 1

      result = body["results"].first
      result["title"].must_match "item 2 of five <span class=\"search-term\">entries</span>"
    end

    it 'properly scopes to more than one repo' do
      make_request("entry", {:repo => "gjtorikian/repo2,gjtorikian/repo4"})

      assert_response response.status, 200
      body = JSON.parse(response.body)
      body["total"].must_equal 2

      result = body["results"].first
      result["title"].must_match "item 2 of five <span class=\"search-term\">entries</span>"
      body["results"][1]["title"].must_match "item 4 of five <span class=\"search-term\">entries</span>"
    end
  end

  describe 'path scoping' do
    setup do
      Branta::IndexManager.create_index(true)

      hash = {
               :title => "item x-1 of five entries",
               :body => fixture("rubbish", "txt"),
               :path => "x/path/1/article",
               :repo => "gjtorikian/repo1"
             }
      Page.create hash

      hash = {
               :title => "item x-y-1 of five entries",
               :body => fixture("rubbish", "txt"),
               :path => "x/y/path/1/article",
               :repo => "gjtorikian/repo1"
             }
      Page.create hash

      Page.gateway.refresh_index!
    end

    it 'properly scopes to a full path' do
      make_request("entry", {:repo => "gjtorikian/repo1", :path => "x/y"})

      assert_response response.status, 200
      body = JSON.parse(response.body)
      body["total"].must_equal 2

      result = body["results"].first
      result["title"].must_match "item x-1 of five <span class=\"search-term\">entries</span>"
    end

    it 'properly scopes to the start of a path' do
      make_request("entry", {:repo => "gjtorikian/repo1", :path => "x"})

      assert_response response.status, 200
      body = JSON.parse(response.body)
      body["total"].must_equal 2

      result = body["results"][1]
      result["title"].must_match "item x-y-1 of five <span class=\"search-term\">entries</span>"
    end
  end

  describe 'required qualifiers' do
    it 'needs the q qualifier' do
      make_request(nil, {:repo => "gjtorikian/repo2"})

      assert_response response.status, 422
      body = JSON.parse(response.body)

      body['error'].must_match "You must provide the 'q' parameter for a query!"
    end

    it 'needs the repo qualifier' do
      make_request("entry")

      assert_response response.status, 422
      body = JSON.parse(response.body)

      body['error'].must_match "You must provide the 'repo' parameter for a query!"
    end
  end
end
