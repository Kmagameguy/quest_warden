require "test_helper"

class GenreTest < ActiveSupport::TestCase
  before do
    @genre = Genre.new(
      id: 123,
      name: "Sandbox"
    )
  end

  describe "validations" do
    it "must be valid with attributes" do
      _(@genre).must_be :valid?
    end

    it "must have an id" do
      @genre.id = nil

      _(@genre).must_be :invalid?
      _(@genre.errors[:id]).must_include "can't be blank"
    end

    it "must have an integer id" do
      @genre.id = "string"

      _(@genre).must_be :invalid?
      _(@genre.errors[:id]).must_include "is not a number"
    end

    it "must have a unique id" do
      @genre.save
      duplicate_genre = @genre.dup
      duplicate_genre.id = @genre.id

      _(duplicate_genre).must_be :invalid?
      _(duplicate_genre.errors[:id]).must_include "has already been taken"
    end

    it "must have a name" do
      @genre.name = nil

      _(@genre).must_be :invalid?
      _(@genre.errors[:name]).must_include "can't be blank"
    end
  end

  describe "associations" do
    it "can have many games" do
      assert @genre.games.is_a?(ActiveRecord::Associations::CollectionProxy)
    end
  end
end
