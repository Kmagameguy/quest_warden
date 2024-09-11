require "test_helper"

class FavoritesControllerTest < ActionDispatch::IntegrationTest
  before do
    @user_params = { id: 1, name: "John Doe", password: "password", password_confirmation: "password" }
    @user = User.create!(@user_params)
    @game = Game.create!(id: 1, name: "My Game", storyline: "this is a storyline", summary: "this is a summary", first_release_date: 798940800)

    # log in first
    post user_sessions_url, params: { user: @user_params.slice(:name, :password, :password_confirmation) }
  end

  describe "#create" do
    it "creates a new favorite for a user & game" do
      post game_favorites_url(@game)

      assert_equal flash[:notice], "#{@game.name} added to favorites!"
      assert_redirected_to @game
    end
  end

  describe "#destroy" do
    it "removes the favorite record" do
      @user.favorites.create!(favoritable: @game)
      delete game_favorites_url(@game)

      assert_equal flash[:notice], "#{@game.name} removed from favorites!"
      assert_empty @user.favorites.to_a
      assert_redirected_to @game
    end
  end
end
