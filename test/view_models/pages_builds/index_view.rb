require 'test_helper'

describe PagesBuilds::IndexView do
  before do
    5.times do |i|
      hash = {
               :owner => "gjtorikian",
               :name => "branta#{i}",
               :name_with_owner => "gjtorikian/branta#{i}",
               :hook_id => i * 8
             }
      Repository.create hash
    end

    @view = PagesBuilds::IndexView.new
    @has_repos_user = OpenStruct.new(:login => "gjtorikian")
    @no_repos_user = OpenStruct.new(:login => "naikirotjg")
  end

  it 'can find repos for people' do
    emptiness = @view.empty_for_user?(@has_repos_user)
    emptiness.must_equal false
  end

  it 'cannot find repos for unknown people' do
    emptiness = @view.empty_for_user?(@no_repos_user)
    emptiness.must_equal true
  end
end
