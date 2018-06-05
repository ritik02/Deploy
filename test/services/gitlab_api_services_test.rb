require 'test_helper'

class GitlabApiServicesTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "Should redirect to home page if users enters Invalid access_token" do
    sign_in users(:two)
    get users_home_url(users(:two))
    assert_response :success
    patch users_home_url(users(:two)) , params: {user: {gitlab_token: decrypt_accesstoken(users(:two).gitlab_token) }}
    assert_response :redirect
    follow_redirect!
    assert_response :success
  end

  test "Should redirect to index page if users enters Valid access_token" do
    sign_in users(:one)
    patch users_home_url(users(:one)) , params: {user: {gitlab_token: decrypt_accesstoken(users(:one).gitlab_token) }}
    assert_response :redirect
    follow_redirect!
    assert_response :success
  end

end
