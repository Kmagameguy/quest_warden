require "test_helper"

class BacklogsControllerTest < ActionDispatch::IntegrationTest
  before do
    @user_params = { id: 1, name: "John Doe", password: "password", password_confirmation: "password" }
    @user = User.create!(@user_params)
    @game = Game.create!(id: 1, name: "My Game", storyline: "this is a storyline", summary: "this is a summary", first_release_date: 798940800)

    post user_sessions_url, params: { user: @user_params }
  end

  describe "#show" do
    it "should show a user's backlog" do
      get user_backlog_url(@user)
      assert_response :success
      assert_select "h1", "Games in #{@user.name}'s Backlog"
    end
  end

  describe "#add_game" do
    it "should add a game to the user's backlog" do
      assert_difference "@user.backlog.games.count", 1 do
        post add_game_user_backlog_url(@user, game_id: @game.id)
      end

      assert_equal flash[:notice], "#{@game.name} was added to your backlog."
      assert_redirected_to game_url(@game)
    end

    it "should not add a game that already exists in the user's backlog" do
      @user.backlog.games << @game
      assert_no_difference "@user.backlog.games.count" do
        post add_game_user_backlog_url(@user, game_id: @game.id)
      end

      assert_equal flash[:alert], "#{@game.name} is already in your backlog!"
      assert_redirected_to game_url(@game)
    end
  end

  describe "#remove_game" do
    it "should remove a game from a user's backlog" do
      @user.backlog.games << @game
      assert_difference "@user.backlog.games.count", -1 do
        delete remove_game_user_backlog_url(@user, game_id: @game.id)
      end

      assert_equal flash[:alert], "#{@game.name} was removed from your backlog."
      assert_redirected_to game_url(@game)
    end
  end
end
