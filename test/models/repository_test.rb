require 'test_helper'

describe Repository do
  it "creates simple repositories" do
    repository = Repository.create :name => "branta", :owner => "gjtorikian"

    expect(repository).to be_valid
    expect(repository).to be_active
  end
end
