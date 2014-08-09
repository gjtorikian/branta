require 'test_helper'

class PagesRepositoryTest < ActiveSupport::TestCase
  describe "the PagesRepository model" do
    it "creates pages repositories" do
      repository = PagesRepository.create :name_with_owner => "branta", :hook_id => 33

      repository.valid?.must_equal true
    end
  end
end
