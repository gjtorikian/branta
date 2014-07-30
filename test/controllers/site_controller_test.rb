require 'test_helper'

describe SiteController do
  it 'should get index' do
    get :index
    assert_response :success
  end
end
