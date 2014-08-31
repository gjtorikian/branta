require 'test_helper'

describe Repository do
  it "creates simple repositories" do
    repository = Repository.create :name => "branta", :owner => "gjtorikian", :name_with_owner => "gjtorikian/branta", :hook_id => "wut"

    repository.valid?.must_equal true
    repository.active?.must_equal true
  end
end
