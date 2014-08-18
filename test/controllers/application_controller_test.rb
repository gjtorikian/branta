require "test_helper"

class ApplicationTestController < ApplicationController
  def index
    render :nothing => true, :status => :accepted
  end
end

describe ApplicationController do
  let(:user_attribs) do
    { "login" => "bhuga",
      "id"    => "123",
      "token" => "A" * 40 }
  end

  it "saves new users" do
    request.env["warden"] = warden.login user_attribs

    get :index

    User.count.must_equal 1

    user = User.first
    user.login.must_equal"bhuga"
    user.github_id.must_equal 123
    user.token.must_equal "A" * 40
  end

  it "updates github tokens and logins for existing users" do
    User.create :login => "bhugas-old-login",
                :github_id => "123",
                :token => "B" * 40

    request.env["warden"] = warden.login user_attribs
    get :index
    User.count.must_equal 1

    user = User.first

    user.login.must_equal "bhuga"
    user.github_id.must_equal 123
    user.token.must_equal "A" * 40
  end
end
