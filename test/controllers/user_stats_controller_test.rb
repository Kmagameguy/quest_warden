require "test_helper"

class UserStatsControllerTest < ActionDispatch::IntegrationTest
  before do
    @user_params = { id: 1, name: "John Doe", password: "password", password_confirmation: "password" }
    @user = User.create!(@user_params)

    post user_sessions_url, params: { user: @user_params }
  end
  describe "#show" do
    it "renders a stats page" do
      get user_stats_url(@user)

      assert_response :success
      assert_select "h1", "#{@user.name}'s Stats"
    end
  end
end
