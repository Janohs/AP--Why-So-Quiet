require "test_helper"

class PasswordResetsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_password_reset_path
    assert_response :success
  end

  test "should create password reset" do
    post password_resets_path, params: { email: "user@example.com" }
    assert_response :redirect
    follow_redirect!
    assert_response :success
  end

  test "should get edit" do
    user = users(:one) # Assuming you have a fixture for users
    user.create_reset_digest
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_response :success
  end

  test "should update password reset" do
    user = users(:one) # Assuming you have a fixture for users
    user.create_reset_digest
    patch password_reset_path(user.reset_token), params: { email: user.email, user: { password: "newpassword", password_confirmation: "newpassword" } }
    assert_response :redirect
    follow_redirect!
    assert_response :success
  end
end
