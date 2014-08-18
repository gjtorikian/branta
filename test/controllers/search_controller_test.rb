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

  describe 'results in the body' do
    it 'can find results in the body' do
      get 'index', {:q => "administrate"}

      assert_response response.status, 200
      body = JSON.parse(response.body)
      body["total"].must_equal 5

      result = body["results"].first

      result["title"].must_equal "item 0 of five entries"
      result["path"].must_equal "/path/0/article"
      result["body"].must_match "<span class=\"search-term\">administrate</span>"
    end

    it 'can take singular words and match plural words in the body' do
      get 'index', {:q => "market"}

      assert_response response.status, 200
      body = JSON.parse(response.body)
      body["total"].must_equal 5

      result = body["results"].first
      result["body"].must_match "<span class=\"search-term\">markets</span>"
    end

    it 'can take plural words and match singular words in the body' do
      get 'index', {:q => "visualizes"}

      assert_response response.status, 200
      body = JSON.parse(response.body)
      body["total"].must_equal 5

      result = body["results"].first
      result["body"].must_match "<span class=\"search-term\">visualize</span>"
    end
  end

  describe 'results in the title' do
    it 'can find results in the title' do
      get 'index', {:q => "item"}

      assert_response response.status, 200
      body = JSON.parse(response.body)
      body["total"].must_equal 5

      result = body["results"].first

      result["title"].must_equal "<span class=\"search-term\">item</span> 0 of five entries"
      result["path"].must_equal "/path/0/article"
      result["body"].must_match "Collaboratively administrate empowered markets via plug-and-play networks. Dynamically procrastinate B2C users after installed base benefits. Dramatically visualize customer directed convergence without revolutionary ROI.…"
    end

    it 'can take singular words and match plural words in the title' do
      get 'index', {:q => "entry"}

      assert_response response.status, 200
      body = JSON.parse(response.body)
      body["total"].must_equal 5

      result = body["results"].first
      result["title"].must_match "item 0 of five <span class=\"search-term\">entries</span>"
    end

    it 'can take plural words and match singular words in the title' do
      get 'index', {:q => "items"}

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
      get 'index', {:q => "administrate"}

      assert_response response.status, 200
      body = JSON.parse(response.body)
      body["total"].must_equal 5
      body["results"].length.must_equal 1
    end

    it 'can get a page of results' do
      get 'index', {:q => "administrate", :page => 4}

      assert_response response.status, 200
      body = JSON.parse(response.body)
      body["total"].must_equal 5

      result = body["results"].first
      result["title"].must_equal "item 3 of five entries"
    end
  end

  describe 'sorting' do
    it 'properly sorts the results' do
      get 'index', {:q => "administrate", :sort => "updated_at", :order => "desc"}

      assert_response response.status, 200
      body = JSON.parse(response.body)
      body["total"].must_equal 5
      body["results"].length.must_equal 5

      result = body["results"].first
      result["title"].must_equal "item 4 of five entries"
    end
  end
end
