require "test_helper"

describe WebhookController do
  before :each do
    stub_meta
  end

  it "does nothing for unhandled events" do
    post "create", fixture("deployment-success"), default_headers("deployment_status")

    assert_response response.status, 404
  end

  it "does nothing for non-successful pagesbuilds" do
    post "create", fixture("pagebuild-errored"), default_headers("pagebuild")

    assert_response response.status, 406
  end

  it "handles events from successful pagesbuilds" do
    post "create", fixture("pagebuild-success"), default_headers("pagebuild")

    assert_response response.status, 201
  end
end
