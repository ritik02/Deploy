require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "should be invalid without username" do
   users(:one).username = nil
   assert_nil users(:one).username
   assert_equal false, users(:one).valid?
 end
end
