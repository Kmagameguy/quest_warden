require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  before do
    @user_params = { name: "John Doe", password: "password", password_confirmation: "password" }
    @user = User.create!(@user_params.merge(id: 1))
  end

  describe "#index" do
    it "should get index when authenticated" do
      post user_sessions_url, params: { user: { name: @user.name, password: @user_params[:password] } }
      get users_url

      assert_response :success
      assert_equal "You have logged in.", flash[:notice]
    end

    it "should redirect to login page when not authenticated" do
      get users_url

      assert_redirected_to new_user_session_url
      assert_equal "You are not authorized to access this resource.", flash[:alert]
    end
  end

  describe "#new" do
    it "should have a new user path" do
      get new_user_url

      assert_response :success
      assert_select "h1", "Create Account"
    end
  end

  describe "#create" do
    it "should create a new user with valid parameters" do
      @valid_user = @user_params.merge(id: 33, name: "Another Game")
      post users_url(user: @valid_user)

      assert_redirected_to root_path
      assert_equal "Sign-up successful. Welcome!", flash[:notice]
    end

    it "should not create a user with invalid parameters" do
      @invalid_user = @user_params.merge(id: 33, name: "")
      post users_url(user: @invalid_user)

      assert_response :unprocessable_entity
      assert_equal "Sign up failed.  Try again.", flash[:alert]
      assert_select "h1", "Create Account"
    end
  end
end
