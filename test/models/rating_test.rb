require "test_helper"

class RatingTest < ActiveSupport::TestCase
  before do
    @game = Game.create!(id: 1, name: "A cool game", storyline: "this is a storyline", summary: "this is a summary", first_release_date: 798940800)
    @user = User.create!(id: 1, name: "John Doe", password: "password", password_confirmation: "password")
  end

  describe "associations" do
    before do
      @rating = Rating.new(user: @user, rateable: @game, value: 3)
    end
    it "should belong to a user" do
      assert_respond_to @rating, :user
      assert_equal @rating.user, @user
    end

    it "should belong to a game" do
      assert_respond_to @rating, :rateable
      assert_equal @rating.rateable, @game
    end
  end

  describe "default_scope" do
    before do
      @game2 = Game.create!(id: 2, name: "A second cool game", storyline: "this is a storyline 2", summary: "This is a summary 2", first_release_date: 798946800)
      Game.all.each_with_index do |game, index|
        Rating.create(user: @user, rateable: game, value: index + 1)
      end
    end

    it "sorts by highest rating by default" do
      highest_rating = Rating.where(user_id: @user.id).maximum(:value).to_f
      first_rating = Rating.where(user_id: @user.id).first.value.to_f

      assert_equal highest_rating, first_rating
    end
  end

  describe "validations" do
    it "is valid with a value within range" do
      described_class::VALID_VALUES.each do |value|
        rating = Rating.new(value: value, user: @user, rateable: @game)

        assert rating.valid?
      end
    end

    it "is not valid with a value outside range" do
      invalid_value = described_class::VALID_VALUES.last + 1
      rating = Rating.new(value: invalid_value, user: @user, rateable: @game)

      assert rating.invalid?
    end
  end

  describe "#game" do
    before do
      @rating = Rating.new(user: @user, rateable: @game, value: 2)
    end
    it "returns a game object if the rateable type is a Game" do
      assert_not_nil @rating.game
    end

    it "returns nil if the rateable type is not a Game" do
      company = Company.create!(id: 1, name: "A company")
      @rating.update!(rateable: company)

      assert_nil @rating.game
    end
  end
end
