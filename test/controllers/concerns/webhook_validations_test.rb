require "test_helper"

describe WebhookValidations do
  class WebhookValidationsTester < WebhookValidations::Validator
    class Request
      def initialize(ip)
        @ip = ip
      end
      attr_accessor :ip
    end
    include WebhookValidations

    def initialize(ip)
      @ip = ip
    end

    def request
      Request.new(@ip)
    end
  end

  before :each do
    stub_meta
  end

  it "makes methods available" do
    klass = WebhookValidationsTester.new("192.30.252.41")
    klass.valid?.must_equal true
    klass = WebhookValidationsTester.new("127.0.0.1")
    klass.valid?.must_equal false
  end

  describe "verifies IPs" do
    it "returns production" do
      WebhookValidations::Validator.new("127.0.0.1").valid?.must_equal false
      WebhookValidations::Validator.new("192.30.252.41").valid?.must_equal true
      WebhookValidations::Validator.new("192.30.252.46").valid?.must_equal true
    end
  end
end
