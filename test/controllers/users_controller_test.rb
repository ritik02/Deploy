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

  test 'check for token validity' do
    gitlab_token = users(:one).gitlab_token
    assert_equal true, check_api_for_valid_token?(gitlab_token)
    gitlab_token = users(:one).gitlab_token + "AA"
    assert_equal false, check_api_for_valid_token?(gitlab_token)
  end

  test 'redirect to home page if token is invalid or empty' do
    sign_in users(:two)
    get users_index_url
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "h3", "HOME PAGE"
  end

  test 'redirect to index page if token is valid' do
    sign_in users(:one)
    get users_home_url
    assert_response :redirect
    follow_redirect!
    assert_response :success
  end

  test "Should redirect to home page if users enters Invalid token" do
    sign_in users(:two)
    get users_home_url(users(:two))
    assert_response :success
    patch users_home_url(users(:two)) , params: {user: {gitlab_token: users(:two).gitlab_token  }}
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "h3" , "HOME PAGE"
  end

  test "Should redirect to index page if users enters Valid token" do
    sign_in users(:two)
    get users_home_url(users(:two))
    assert_response :success
    patch users_home_url(users(:two)) , params: {user: {gitlab_token: users(:one).gitlab_token  }}
    assert_response :redirect
    follow_redirect!
    assert_response :success
  end




end
