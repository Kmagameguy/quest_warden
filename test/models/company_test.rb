require "test_helper"

class CompanyTest < ActiveSupport::TestCase
  before do
    @company = Company.new(
      id: 444,
      name: "Cool Company",
      country: "US"
    )
  end

  describe "validations" do
    it "must be valid with attributes" do
      _(@company).must_be :valid?
    end

    it "must have an id" do
      @company.id = nil
      _(@company).must_be :invalid?
      _(@company.errors[:id]).must_include "can't be blank"
    end

    it "must have an integer id" do
      @company.id = "string"
      _(@company).must_be :invalid?
      _(@company.errors[:id]).must_include "is not a number"
    end

    it "must have a unique id" do
      @company.save
      duplicate_company = @company.dup
      duplicate_company.id = @company.id

      _(duplicate_company).must_be :invalid?
      _(duplicate_company.errors[:id]).must_include "has already been taken"
    end

    it "must have a name" do
      @company.name = nil
      _(@company).must_be :invalid?
      _(@company.errors[:name]).must_include "can't be blank"
    end
  end

  describe "associations" do
    it "can have a parent company" do
      @parent_company = Company.create(
        id: @company.id - 1,
        name: "SuperCompany"
      )

      @company.parent = @parent_company
      assert_equal @company.parent, @parent_company
    end

    it "can have many subsidiaries" do
      assert @company.companies.is_a?(ActiveRecord::Associations::CollectionProxy)
    end

    it "can have many games" do
      assert @company.games.is_a?(ActiveRecord::Associations::CollectionProxy)
    end

    it "can have many developers" do
      assert @company.developed_games.is_a?(ActiveRecord::Associations::CollectionProxy)
    end

    it "can have many published games" do
      assert @company.published_games.is_a?(ActiveRecord::Associations::CollectionProxy)
    end

    it "can port many games" do
      assert @company.ported_games.is_a?(ActiveRecord::Associations::CollectionProxy)
    end

    it "can support contributions to many games" do
      assert @company.game_contributions.is_a?(ActiveRecord::Associations::CollectionProxy)
    end
  end
end
