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
end
