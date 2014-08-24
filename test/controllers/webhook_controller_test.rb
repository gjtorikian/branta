require "test_helper"

describe WebhookController do
  setup do
    stub_meta
  end

  it "does nothing for unhandled events" do
    default_headers("deployment_status").each_pair { |key, value| @request.env[key] = value }
    post "create", fixture("deployment-success")

    response.status.must_equal 404
  end

  it "does nothing for events from strange IPs" do
    default_headers("page_build", "192.32.73.100").each_pair { |key, value| @request.env[key] = value }
    post "create", fixture("pagebuild-success")

    response.status.must_equal 404
  end

  describe 'valid page_build scenarios' do
    before do
      default_headers("page_build").each_pair { |key, value| @request.env[key] = value }
      ENV.delete('GITHUB_BRANTA_ORG_NAME')
    end

    it "does nothing for non-successful pagesbuilds" do
      post "create", fixture("pagebuild-errored")

      response.status.must_equal 406
    end

    it "handles events from successful pagesbuilds" do
      post "create", fixture("pagebuild-success")

      response.status.must_equal 201
    end

    it "blocks non-org repos from pushing" do
      ENV['GITHUB_BRANTA_ORG_NAME'] = 'github'
      post "create", fixture("pagebuild-success")

      response.status.must_equal 406
    end

    it "allows org repos to push" do
      ENV['GITHUB_BRANTA_ORG_NAME'] = 'github'
      post "create", fixture("org-pagebuild-success")

      response.status.must_equal 201
    end
  end
end
