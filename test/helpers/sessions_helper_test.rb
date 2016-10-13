require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

  def setup
    @user = users(:wayne)
    remember(@user)
  end

  test "current_user returns right user when session is nil" do
    assert_equal @user, current_user
    assert_equal @user.remember_token, cookies['remember_token']
    assert is_logged_in?
  end

  test "current_user returns nil when remember digest is wrong" do
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end
end
