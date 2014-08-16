require 'test_helper'

describe PagesBuild do
  let(:payload) { fixture('pagebuild') }
  let(:data) { JSON.parse(payload)['payload'] }

  let(:create_data) {
    {
      :guid            => SecureRandom.uuid,
      :name            => "hubot",
      :name_with_owner => "github/hubot",
      :ref             => "master",
      :sha             => "f24b8008",
      :status          => "success"
    }
  }

  it "works with dynamic finders" do
    pagesbuild = PagesBuild.create create_data
    pagesbuild.valid?.must_equal true
  end

  it "#latest_for_name_with_owner" do
    present = [ ]
    PagesBuild.create create_data
    present << PagesBuild.create(create_data)

    PagesBuild.create create_data.merge(:name => "mybot")
    present << PagesBuild.create(create_data.merge(:name => "mybot"))

    PagesBuild.create create_data.merge(:name_with_owner => "gjtorikian/branta")

    present << PagesBuild.create(create_data.merge(:status => "errored"))

    pagesbuild = PagesBuild.latest_for_name_with_owner("github/hubot")

    pagesbuild.size.must_equal 3
    pagesbuild.must_equal present
  end
end
