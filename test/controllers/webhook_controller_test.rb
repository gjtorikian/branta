require 'test_helper'

describe WebhookController do
  it "should create new PagesRepository" do
    assert_equal PagesRepository.all.count, 0

    @create_hook = json_fixture("create_hook")

    WebhookController.any_instance.stubs(:create_hook).returns(@create_hook.symbolize_keys)

    post :create, name: "gjtorikian/branta", :format => 'json'

    assert_equal PagesRepository.all.count, 1
  end

  it "should remove PagesRepository" do
    pages_repository = Factory.create :pages_repository
    assert_equal PagesRepository.all.count, 1

    WebhookController.any_instance.stubs(:remove_hook).returns(true)

    delete :delete, name: pages_repository.name_with_owner, :format => 'json'

    assert_equal PagesRepository.all.count, 0
  end
end
