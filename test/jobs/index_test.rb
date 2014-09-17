require 'test_helper'

describe Branta::Jobs::Index do
  let(:guid) do
    123456
  end

  let(:payload) do
    JSON.parse fixture("pagebuild-success")
  end

  let(:repository) do
    {
      :owner => "baxterthehacker",
      :name => "public-repo",
      :id => 4
    }
  end

  let(:pages_data) do
    JSON.parse fixture("pages")
  end

  let(:sitemap) do
    fixture("sitemap", "xml")
  end

  let(:robotstxt_permit) do
    fixture("robotstxt_permit", "txt")
  end

  let(:robotstxt_deny) do
    fixture("robotstxt_deny", "txt")
  end

  describe 'parsing cnames' do
    it 'deals with an existing CNAME' do
      body_hash = { :content => "eWVzLnJlYWwuc2l0ZQo=" }

      stub_request(:get, "https://api.github.com/repos/baxterthehacker/public-repo/contents/CNAME?client_id=%3Cunknown-client-id%3E&client_secret=%3Cunknown-client-secret%3E").
        with(:headers => {'Accept'=>'application/vnd.github.v3+json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>"Octokit Ruby Gem #{octokit_version}"}).
        to_return(:status => 200, :body => body_hash, :headers => {})

      Branta::Jobs::Index.stubs(:repo_name_with_owner).returns("baxterthehacker/public-repo")

      Branta::Jobs::Index.domain_name.must_equal "http://yes.real.site"
    end

    it 'deals with a missing CNAME' do
      stub_request(:get, "https://api.github.com/repos/baxterthehacker/public-repo/contents/CNAME?client_id=%3Cunknown-client-id%3E&client_secret=%3Cunknown-client-secret%3E").
        with(:headers => {'Accept'=>'application/vnd.github.v3+json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>"Octokit Ruby Gem #{octokit_version}"}).
        to_return(:status => 404, :body => "", :headers => {})

      Branta::Jobs::Index.stubs(:repo_name_with_owner).returns("baxterthehacker/public-repo")
      Branta::Jobs::Index.stubs(:repo_owner).returns("baxterthehacker")
      Branta::Jobs::Index.stubs(:repo_name).returns("public-repo")

      Branta::Jobs::Index.domain_name.must_equal "http://baxterthehacker.github.io/public-repo"
    end
  end

  # focus
  describe 'parsing sitemaps' do

    describe 'dealing with an existing sitemap' do
      it 'works when there is a permissive robotstxt' do
        Branta::Jobs::Index.stubs(:domain_name).returns("http://ben.balter.com")
        Branta.robot.expects(:get).returns(true)

        stub_request(:get, "http://ben.balter.com/sitemap.xml").
          with(:headers => {'User-Agent'=>'Typhoeus - https://github.com/typhoeus/typhoeus'}).
          to_return(:status => 200, :body => sitemap, :headers => {})

        stub_request(:get, "http://ben.balter.com/robots.txt").
          with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => robotstxt_permit, :headers => {})

        # don't really care about the body here, only that we get urls
        stub_request(:get, /ben\.balter\.com\/2014\//)

        Branta::Jobs::Index.perform(guid, payload, repository)

        assert_requested :get, /ben\.balter\.com\/2014\//, :times => 2
      end

      it 'works when there is a missing robotstxt' do
        Branta::Jobs::Index.stubs(:domain_name).returns("http://ben.balter.com")
        Branta.robot.expects(:get).returns(false)

        stub_request(:get, "http://ben.balter.com/sitemap.xml").
          with(:headers => {'User-Agent'=>'Typhoeus - https://github.com/typhoeus/typhoeus'}).
          to_return(:status => 200, :body => sitemap, :headers => {})

        stub_request(:get, "http://ben.balter.com/robots.txt").
          with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => "", :headers => {})

        # don't really care about the body here, only that we get urls
        stub_request(:get, /ben\.balter\.com\/2014\//)

        Branta::Jobs::Index.perform(guid, payload, repository)

        assert_requested :get, /ben\.balter\.com\/2014\//, :times => 2
      end

      it 'does not work when robotstxt denies it' do
        Branta::Jobs::Index.stubs(:domain_name).returns("http://ben.balter.com")

        stub_request(:get, "http://ben.balter.com/sitemap.xml").
          with(:headers => {'User-Agent'=>'Typhoeus - https://github.com/typhoeus/typhoeus'}).
          to_return(:status => 200, :body => sitemap, :headers => {})

        stub_request(:get, "http://ben.balter.com/robots.txt").
          with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => robotstxt_deny, :headers => {})

        # don't really care about the body here, only that we get urls
        stub_request(:get, /ben\.balter\.com\/2014\//)

        Branta::Jobs::Index.perform(guid, payload, repository)
      end
    end

    describe 'deals with a missing sitemap' do

      it 'works when there is a permissive robotstxt' do
        Branta::Jobs::Index.stubs(:get_sitemap).returns(nil)
        Branta::Jobs::Index.stubs(:domain_name).returns("http://ben.balter.com")
        Branta::Jobs::Index.stubs(:robotstxt_allows_url?).returns(true)

        stub_request(:get, "http://ben.balter.com/robots.txt").
          with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => robotstxt_permit, :headers => {})

        Anemone.expects(:crawl).with("http://ben.balter.com", {:discard_page_bodies => true}).returns(true)

        Branta::Jobs::Index.perform(guid, payload, repository)
      end

      it 'works when there is a missing robotstxt' do
        Branta::Jobs::Index.stubs(:get_sitemap).returns(nil)
        Branta::Jobs::Index.stubs(:domain_name).returns("http://ben.balter.com")
        Branta.robot.expects(:get).returns(false)

        stub_request(:get, "http://ben.balter.com/robots.txt").
          with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
          to_return(:status => 404)

        Anemone.expects(:crawl).with("http://ben.balter.com", {:discard_page_bodies => true}).returns(true)

        # don't really care about the body here, only that we get urls
        stub_request(:get, /ben\.balter\.com/)

        Branta::Jobs::Index.perform(guid, payload, repository)
      end

      it 'does not work when robotstxt denies it' do
        Branta::Jobs::Index.stubs(:get_sitemap).returns(nil)
        Branta::Jobs::Index.stubs(:domain_name).returns("http://ben.balter.com")
        Branta::Jobs::Index.stubs(:robotstxt_allows_url?).returns(false)

        stub_request(:get, "http://ben.balter.com/robots.txt").
          with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => robotstxt_deny, :headers => {})

        stub_request(:get, "http://ben.balter.com/robots.txt").
          with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => robotstxt_deny, :headers => {})

        Anemone.expects(:crawl).with("http://ben.balter.com", {:discard_page_bodies => true}).once

        Branta::Jobs::Index.perform(guid, payload, repository)

        assert_requested :get, /ben\.balter\.com\/2014\//, :times => 0
      end
    end
  end

  describe 'indexing content' do
    before do
      Branta::IndexManager.create_index(true)
    end

    it 'skips content with meta-refresh headers' do
      skip "Works locally, not on Travis"
      Branta::Jobs::Index.index_page("/redirect_content", fixture("redirect_content", "html"))
      Page.gateway.refresh_index!

      Page.count.must_equal 0
    end

    it 'properly indexes new pages' do
      Branta::Jobs::Index.stubs(:repo_name_with_owner).returns("baxterthehacker/public-repo")
      Branta::Jobs::Index.index_page("/signs_of_life", fixture("signs_of_life", "html"))
      Page.gateway.refresh_index!

      Page.count.must_equal 1
    end

    it 'properly plucks information' do
      Branta::Jobs::Index.stubs(:repo_name_with_owner).returns("baxterthehacker/public-repo")
      doc = Branta::Jobs::Index.index_page("/signs_of_life", fixture("signs_of_life", "html"))

      doc[:title].first.must_equal "Signs Of Life"
      doc[:path].must_equal "/signs_of_life"
      doc[:last_updated].strftime('%a, %d %b %Y %H:%M:%S').must_equal DateTime.parse("Wed, 25 Jul 2012 12:00:00")
      doc[:body].must_match /It started as I was picking up toys/
      doc[:repo].must_equal "baxterthehacker/public-repo"

    end
  end
end
