require 'test_helper'

class UserFlowTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

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
