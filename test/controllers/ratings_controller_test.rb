require "test_helper"

class RatingsControllerTest < ActionDispatch::IntegrationTest
  before do
    @user_params = { id: 1, name: "John Doe", password: "password", password_confirmation: "password" }
    @user = User.create!(@user_params)
    @game = Game.create!(id: 1, name: "My Game", storyline: "this is a storyline", summary: "this is a summary", first_release_date: 798940800)
    @rating_params = { rateable_type: "Game", rateable_id: @game.id, value: 4.0 }
  end

  describe "#create" do
    before do
      # log in first
      post user_sessions_url, params: { user: { name: @user_params[:name], password: @user_params[:password] } }
    end

    it "should create a rating for a game" do
      post game_ratings_url(@game), params: { rating: @rating_params }

      assert_equal flash[:notice], "Rating successfully submitted."
      assert_redirected_to @game
      assert @game.ratings.where(user: @user, rateable_id: @game.id, value: 4.0).exists?
    end

    it "should create a rating and remove the game from the user's backlog" do
      @user.backlog.games << @game
      post game_ratings_url(@game), params: { rating: @rating_params }

      assert_equal flash[:notice], "Rating submitted and #{@game.name} was removed from backlog."
      assert_redirected_to @game
      assert @game.ratings.where(user: @user, rateable_id: @game.id, value: 4.0).exists?
    end

    it "should be able to update an existing rating" do
      rating = @game.ratings.create!(user: @user, value: 2.0)
      patch game_rating_url(@game, rating), params: { rating: @rating_params }

      assert_equal flash[:notice], "Rating successfully updated."
      assert_redirected_to @game
      assert rating.reload.value == 4.0
    end

    it "should not create a rating with an invalid value" do
      post game_ratings_url(@game), params: { rating: @rating_params.merge(value: 0) }

      assert_equal flash[:alert], "There was an error submitting your rating."
      assert_redirected_to @game
    end

    it "should not create a rating with a blank value" do
      post game_ratings_url(@game), params: { rating: @rating_params.merge(value: "") }

      assert_equal flash[:alert], "Rating cannot be blank."
      assert_redirected_to @game
    end

    it "should not update a rating with an invalid value" do
      rating = @game.ratings.create!(user: @user, value: 2.0)
      patch game_rating_url(@game, rating), params: { rating: @rating_params.merge(value: 7) }

      assert_equal flash[:alert], "There was an error updating your rating."
      assert_redirected_to @game
    end

    it "should destroy a rating when 'select a rating' is chosen" do
      rating = @game.ratings.create!(user: @user, value: 2.0)
      patch game_rating_url(@game, rating), params: { rating: @rating_params.merge(value: "") }

      assert_equal flash[:notice], "Rating successfully removed."
      assert_redirected_to @game
    end
  end
end
