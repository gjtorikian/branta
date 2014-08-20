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

  it 'deals with an existing CNAME' do
    stub_request(:get, "https://api.github.com/repos/baxterthehacker/public-repo/contents/CNAME?client_id=%3Cunknown-client-id%3E&client_secret=%3Cunknown-client-secret%3E").
      with(:headers => {'Accept'=>'application/vnd.github.v3+json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>'Octokit Ruby Gem 3.3.1'}).
      to_return(:status => 200, :body => "yes.real.site", :headers => {})

    Branta::Jobs::Index.stubs(:name_with_owner).returns("baxterthehacker/public-repo")

    Branta::Jobs::Index.domain_name.must_equal "http://yes.real.site"
  end

  it 'deals with a missing CNAME' do
    stub_request(:get, "https://api.github.com/repos/baxterthehacker/public-repo/contents/CNAME?client_id=%3Cunknown-client-id%3E&client_secret=%3Cunknown-client-secret%3E").
      with(:headers => {'Accept'=>'application/vnd.github.v3+json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>'Octokit Ruby Gem 3.3.1'}).
      to_return(:status => 404, :body => "", :headers => {})

    Branta::Jobs::Index.stubs(:name_with_owner).returns("baxterthehacker/public-repo")
    Branta::Jobs::Index.stubs(:owner).returns("baxterthehacker")
    Branta::Jobs::Index.stubs(:name).returns("public-repo")

    Branta::Jobs::Index.domain_name.must_equal "http://baxterthehacker.github.io/public-repo"
  end

  it 'deals with an existing sitemap' do
    Branta::Jobs::Index.stubs(:get_sitemap).returns("http://ben.balter.com/sitemap.xml")

    stub_request(:get, "http://ben.balter.com/sitemap.xml").
      with(:headers => {'User-Agent'=>'Typhoeus - https://github.com/typhoeus/typhoeus'}).
      to_return(:status => 200, :body => sitemap, :headers => {})

    # don't really care about the body here, only that we get urls
    stub_request(:get, /ben\.balter\.com\/2014\//)

    Branta::Jobs::Index.perform(guid, payload, repository)

    assert_requested :get, /ben\.balter\.com\/2014\//, :times => 2
  end

  it 'deals with a missing sitemap' do
    Branta::Jobs::Index.stubs(:get_sitemap).returns(nil)
    Branta::Jobs::Index.stubs(:domain_name).returns("http://somesite")

    Anemone.expects(:crawl).with("http://somesite", {:discard_page_bodies => true}).returns(true)

    Branta::Jobs::Index.perform(guid, payload, repository)
  end
end
