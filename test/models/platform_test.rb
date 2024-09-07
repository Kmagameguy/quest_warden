require "test_helper"

class PlatformTest < ActiveSupport::TestCase
  before do
    @platform = Platform.new(
      id: 111,
      name: "LandStation GameSphere"
    )
  end

  describe "validations" do
    it "must be valid with attributes" do
      _(@platform).must_be :valid?
    end

    it "must have an id" do
      @platform.id = nil
      _(@platform).must_be :invalid?
      _(@platform.errors[:id]).must_include "can't be blank"
    end

    it "must have an integer id" do
      @platform.id = "string"
      _(@platform).must_be :invalid?
      _(@platform.errors[:id]).must_include "is not a number"
    end

    it "must have a unique id" do
      @platform.save
      duplicate_platform = @platform.dup
      duplicate_platform.id = @platform.id
      _(duplicate_platform).must_be :invalid?
      _(duplicate_platform.errors[:id]).must_include "has already been taken"
    end

    it "must have a name" do
      @platform.name = nil
      _(@platform).must_be :invalid?
      _(@platform.errors[:name]).must_include "can't be blank"
    end
  end

  describe "associations" do
    it "can have many games" do
      assert @platform.games.is_a?(ActiveRecord::Associations::CollectionProxy)
    end
  end
end
