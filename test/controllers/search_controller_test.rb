require "test_helper"

describe SearchController do
  setup do
    Branta::IndexManager.create_index(true)
    5.times do |i|
      hash = {
               :title => "item #{i} of five entries",
               :body => "Collaboratively administrate empowered markets via plug-and-play networks. Dynamically procrastinate B2C users after installed base benefits. Dramatically visualize customer directed convergence without revolutionary ROI.",
               :path => "/path/#{i}/article"
             }
      Page.create hash
    end
    Page.gateway.refresh_index!
  end

  # there seems to be some kind of timing issue on Travis, and the only fix is to
  # explicitly ask for the sort and order
  def make_request(q, p = nil, s = nil, o = nil)
    if ENV['IS_CI']
      sort = s || "created_at"
      order = 0 || "asc"
      get 'index', {:q => q, :page => p, :sort => sort, :order => o}
    else
      get 'index', {:q => q, :page => p, :sort => s, :order => o}
    end
  end

  describe 'results in the body' do
    it 'can find results in the body' do
      make_request("administrate")

      assert_response response.status, 200
      body = JSON.parse(response.body)
      body["total"].must_equal 5

      result = body["results"].first

      result["title"].must_equal "item 0 of five entries"
      result["path"].must_equal "/path/0/article"
      result["body"].must_match "<span class=\"search-term\">administrate</span>"
    end

    it 'can take singular words and match plural words in the body' do
      make_request("market")

      assert_response response.status, 200
      body = JSON.parse(response.body)
      body["total"].must_equal 5

      result = body["results"].first
      result["body"].must_match "<span class=\"search-term\">markets</span>"
    end

    it 'can take plural words and match singular words in the body' do
      make_request("visualizes")

      assert_response response.status, 200
      body = JSON.parse(response.body)
      body["total"].must_equal 5

      result = body["results"].first
      result["body"].must_match "<span class=\"search-term\">visualize</span>"
    end
  end

  describe 'results in the title' do
    it 'can find results in the title' do
      make_request("item")

      assert_response response.status, 200
      body = JSON.parse(response.body)
      body["total"].must_equal 5

      result = body["results"].first

      result["title"].must_equal "<span class=\"search-term\">item</span> 0 of five entries"
      result["path"].must_equal "/path/0/article"
      result["body"].must_match "Collaboratively administrate empowered markets via plug-and-play networks. Dynamically procrastinate B2C users after installed base benefits. Dramatically visualize customer directed convergence without revolutionary ROI.…"
    end

    it 'can take singular words and match plural words in the title' do
      make_request("entry")

      assert_response response.status, 200
      body = JSON.parse(response.body)
      body["total"].must_equal 5

      result = body["results"].first
      result["title"].must_match "item 0 of five <span class=\"search-term\">entries</span>"
    end

    it 'can take plural words and match singular words in the title' do
      make_request("items")

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
      make_request("administrate")

      assert_response response.status, 200
      body = JSON.parse(response.body)
      body["total"].must_equal 5
      body["results"].length.must_equal 1
    end

    it 'can get a page of results' do
      make_request("administrate", 4)

      assert_response response.status, 200
      body = JSON.parse(response.body)
      body["total"].must_equal 5

      result = body["results"].first
      result["title"].must_equal "item 3 of five entries"
    end
  end

  describe 'sorting' do
    it 'properly sorts the results' do
      make_request("administrate", nil, "updated_at", "desc")

      assert_response response.status, 200
      body = JSON.parse(response.body)
      body["total"].must_equal 5
      body["results"].length.must_equal 5

      result = body["results"].first
      result["title"].must_equal "item 4 of five entries"
    end
  end
end
