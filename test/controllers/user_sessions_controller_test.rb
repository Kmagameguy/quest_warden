require "test_helper"

class UserSessionsControllerTest < ActionDispatch::IntegrationTest
  before do
    @user_params = { name: "John Doe", password: "password", password_confirmation: "password" }
    @user = User.create!(@user_params.merge(id: 1))
  end

  describe "#new" do
    it "should render a new form" do
      get new_user_session_url

      assert_response :success
      assert_select "h1", "Login Page"
    end
  end

  describe "#create" do
    it "should authenticate a user with the proper credentials" do
      post user_sessions_url(user: @user_params)

      assert_redirected_to root_path
      assert_equal flash[:notice], "You have logged in."
    end

    it "should not authenticate a user with invalid credentials" do
      @invalid_user = @user_params.merge(id: 33, name: "")
      post user_sessions_url(user: @invalid_user)

      assert_redirected_to new_user_session_url
      assert_equal flash[:alert], "Login failed"
    end
  end

  describe "#destroy" do
    before do
      post user_sessions_url(user: @user_params)
    end
    it "should destroy the session and log out the user" do
      assert_not_nil session[:user_id]
      delete user_session_url(session[:user_id])

      assert_nil session[:user_id]
      assert_equal flash[:notice], "You have been logged out."
      assert_redirected_to root_path
    end
  end
end
