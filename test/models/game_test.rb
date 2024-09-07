require "test_helper"

class GameTest < ActiveSupport::TestCase
  before do
    @game = Game.new(
      id: 555,
      name: "My Game",
      storyline: "Here's a story",
      summary: "And a summary",
      first_release_date: 798940800
    )
  end

  describe "validations" do
    it "must be valid with valid attributes" do
      _(@game).must_be :valid?
    end

    it "must have an id" do
      @game.id = nil

      _(@game).must_be :invalid?
      _(@game.errors[:id]).must_include "can't be blank"
    end

    it "must have an integer id" do
      @game.id = "string"

      _(@game).must_be :invalid?
      _(@game.errors[:id]).must_include "is not a number"
    end

    it "must have a unique id" do
      @game.save
      duplicate_game = @game.dup
      duplicate_game.id = @game.id

      _(duplicate_game).must_be :invalid?
      _(duplicate_game.errors[:id]).must_include "has already been taken"
    end

    it "must have a name" do
      @game.name = nil

      _(@game).must_be :invalid?
      _(@game.errors[:name]).must_include "can't be blank"
    end
  end

  describe "associations" do
    it "can have many platforms" do
      assert @game.platforms.is_a?(ActiveRecord::Associations::CollectionProxy)
    end

    it "can have many genres" do
      assert @game.genres.is_a?(ActiveRecord::Associations::CollectionProxy)
    end

    it "can have many developers" do
      assert @game.developers.is_a?(ActiveRecord::Associations::CollectionProxy)
    end

    it "can have many publishers" do
      assert @game.publishers.is_a?(ActiveRecord::Associations::CollectionProxy)
    end

    it "can have many companies that ported it" do
      assert @game.ported_by.is_a?(ActiveRecord::Associations::CollectionProxy)
    end

    it "can have many contributing companies" do
      assert @game.supporting_companies.is_a?(ActiveRecord::Associations::CollectionProxy)
    end
  end

  describe "#first_release_date" do
    it "should return a formatted first_release_date" do
      assert_equal @game.first_release_date, "Wed, 26 Apr 1995 20:00:00 -0400"
    end

    it "should return nil if first_release_date is not present" do
      @game.first_release_date = nil

      assert_nil @game.first_release_date
    end
  end

  describe "#first_release_date?" do
    it "returns true when the first_release_date attribute exists" do
      assert @game.first_release_date?
    end

    it "returns false when the first_release_date attribute does not exist" do
      @game.first_release_date = nil

      assert_not @game.first_release_date?
    end
  end
end
