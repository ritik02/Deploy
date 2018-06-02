require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "should get index" do
    get users_index_url
    assert_response :redirect
    follow_redirect!
    assert_response :found
  end

  test 'authenticated users can GET index' do
    sign_in users(:one)
    get users_index_url
    assert_response :success
  end

end
