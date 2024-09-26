require "test_helper"

class UserTest < ActiveSupport::TestCase
  before do
    @valid_password = "secure_password"
    @user = User.new(
      id: 111,
      name: "Test User",
      password: @valid_password,
      password_confirmation: @valid_password
    )

    @game = Game.create!(id: 1, name: "A cool game", storyline: "this is a storyline", summary: "this is a summary", first_release_date: 798940800)
    @game2 = Game.create!(id: 2, name: "Another cool game", storyline: "this is a storyline", summary: "this is a summary", first_release_date: 798940805)
  end

  describe "validations" do
    it "is valid with attributes" do
      _(@user).must_be :valid?
    end

    it "must have a name" do
      @user.name = nil

      _(@user).must_be :invalid?
      _(@user.errors[:name]).must_include "can't be blank"
    end

    it "must have a matching password confirmation" do
      @user.password_confirmation = "mismatch"

      _(@user).must_be :invalid?
      _(@user.errors[:password_confirmation]).must_include "doesn't match Password"
    end
  end

  describe "associations" do
    it "can have many ratings" do
      rating = Rating.new(value: 1.5, user: @user, rateable: @game)

      assert_respond_to @user, :ratings
      assert_equal rating.user, @user
    end

    it "can have many favorites" do
      assert_respond_to @user, :favorites
    end

    it "should have one backlog" do
      assert_respond_to @user, :backlog
    end

    it "should automatically create a backlog when a user is created" do
      new_user = User.create(id: @user.id + 1, name: "Jane Doe", password: "password", password_confirmation: "password")
      assert_not_nil new_user.backlog
    end
  end

  describe "password authentication" do
    before do
      @user.save
    end

    it "will authenticate with a valid password" do
      authenticated_user = User.find_by(name: @user.name).authenticate(@valid_password)
      assert_equal @user, authenticated_user
    end

    it "will not authenticate with an invalid password" do
      authenticated_user = User.find_by(name: @user.name).authenticate("wrong_password")
      assert_not authenticated_user
    end
  end

  describe "#favorited?" do
    it "returns true if a user has favorited the resource" do
      Favorite.create!(user: @user, favoritable: @game)

      assert @user.favorited?(@game)
    end

    it "returns false if a user has not favorited the resource" do
      assert_not @user.favorited?(@game)
    end
  end

  describe "#favorite_games" do
    it "returns a list of games that have been favorited" do
      Favorite.create!(user: @user, favoritable: @game)

      assert_includes @user.favorite_games, @game
    end

    it "returns an empty array if the user has not favorited anything yet" do
      assert_empty @user.favorite_games
    end
  end

  describe "#highest_rated_games" do
    it "returns a list of games whose rating is the highest" do
      Game.all.each_with_index do |game, index|
        Rating.create!(user: @user, rateable: game, value: index + 1)
      end

      assert_equal 1, @user.highest_rated_games.size
      assert_includes @user.highest_rated_games, @game2
    end

    it "returns an empty array if the user has not rated anything yet" do
      assert_empty @user.highest_rated_games
    end
  end

  describe "#lowest_rated_games" do
    it "returns a list of games whose rating is the lowest" do
      Game.all.each_with_index do |game, index|
        Rating.create!(user: @user, rateable: game, value: index + 1)
      end

      assert_equal 1, @user.lowest_rated_games.size
      assert_includes @user.lowest_rated_games, @game
    end

    it "returns an empty array if the user has not rated anything yet" do
      assert_empty @user.lowest_rated_games
    end
  end
end
