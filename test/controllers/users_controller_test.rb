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

  test 'check for access_token validity' do
    gitlab_token = decrypt_accesstoken(users(:one).gitlab_token)
    assert_equal true, check_api_for_valid_token?(gitlab_token)
    gitlab_token = users(:one).gitlab_token + "AA"
    assert_equal false, check_api_for_valid_token?(gitlab_token)
  end

  test 'redirect to home page if access_token is invalid' do
    sign_in users(:two)
    get users_index_url
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "h3", "HOME PAGE"
  end

  test 'redirect to home page if access_token is empty' do
    sign_in users(:three)
    get users_index_url
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "h3", "HOME PAGE"
  end

  test 'redirect to index page if access_token is valid' do
    sign_in users(:one)
    get users_home_url
    assert_response :redirect
    follow_redirect!
    assert_response :success
  end


end
