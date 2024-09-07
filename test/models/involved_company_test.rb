require "test_helper"

class InvolvedCompanyTest < ActiveSupport::TestCase
  before do
    @game = Game.create(
      id: 111,
      name: "My Cool Game",
      storyline: "Here's a story",
      summary: "Here's a summary",
      first_release_date: 798940800
    )

    @company = Company.create(
      id: 333,
      name: "SuperCompany",
      country: "US"
    )

    @involved_company = InvolvedCompany.new(
      id: 101,
      game_id: @game.id,
      company_id: @company.id
    )
  end

  describe "validations" do
    it "must be valid with attributes" do
      _(@involved_company).must_be :valid?
    end

    it "must have an id" do
      @involved_company.id = nil

      _(@involved_company).must_be :invalid?
      _(@involved_company.errors[:id]).must_include "can't be blank"
    end

    it "must have an integer id" do
      @involved_company.id = "string"

      _(@involved_company).must_be :invalid?
      _(@involved_company.errors[:id]).must_include "is not a number"
    end

    it "must have a unique id" do
      @involved_company.save
      duplicate_involved_company = @involved_company.dup
      duplicate_involved_company.id = @involved_company.id

      _(duplicate_involved_company).must_be :invalid?
      _(duplicate_involved_company.errors[:id]).must_include "has already been taken"
    end

    it "must be associated with a game" do
      assert @involved_company.game.is_a?(Game)
    end

    it "must be associated with a company" do
      assert @involved_company.company.is_a?(Company)
    end
  end

  describe "scopes" do
    it "can find developers" do
      @involved_company.developer = true
      @involved_company.save

      assert InvolvedCompany.developers.include?(@involved_company)
    end

    it "can find publishers" do
      @involved_company.publisher = true
      @involved_company.save

      assert InvolvedCompany.publishers.include?(@involved_company)
    end

    it "can find porters" do
      @involved_company.porting = true
      @involved_company.save

      assert InvolvedCompany.porting.include?(@involved_company)
    end

    it "can find contributing companies" do
      @involved_company.supporting = true
      @involved_company.save

      assert InvolvedCompany.supporting.include?(@involved_company)
    end
  end
end
