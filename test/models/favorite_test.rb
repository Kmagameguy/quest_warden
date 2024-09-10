require "test_helper"

class FavoriteTest < ActiveSupport::TestCase
  before do
    @game = Game.create!(id: 1, name: "A cool game", storyline: "this is a storyline", summary: "this is a summary", first_release_date: 798940800)
    @user = User.create!(id: 1, name: "John Doe", password: "password", password_confirmation: "password")
  end

  describe "associations" do
    before do
      @favorite = Favorite.new(user: @user, favoritable: @game)
    end

    it "should belong to a user" do
      assert_respond_to @favorite, :user
      assert_equal @favorite.user, @user
    end

    it "should belong to a game" do
      assert_respond_to @favorite, :favoritable
      assert_equal @favorite.favoritable, @game
    end
  end
end
