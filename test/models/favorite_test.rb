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

  describe "validations" do
    it "is valid with valid attributes" do
      favorite = Favorite.new(user: @user, favoritable: @game)

      assert favorite.valid?
    end

    it "is not valid without a user" do
      favorite = Favorite.new(favoritable: @game)

      assert_not favorite.valid?
      assert_includes favorite.errors[:user], "can't be blank"
    end

    it "is not valid without a favoritable resource" do
      favorite = Favorite.new(user: @user)

      assert_not favorite.valid?
      assert_includes favorite.errors[:favoritable], "can't be blank"
    end
  end
end
