require 'test_helper'

describe WelcomeController do
  it 'should get index' do
    get :index
    assert_response :success
  end
end
