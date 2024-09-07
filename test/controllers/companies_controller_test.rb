require "test_helper"

class CompanyControllerTest < ActionDispatch::IntegrationTest
  before do
    @first_company = Company.create!(id: 1, name: "Company1", country: "US")
    @second_company = Company.create!(id: 2, name: "Company2", country: "US")
  end
  describe "#index" do
    it "has an index" do
      get companies_url
      assert_response :success
    end
  end

  describe "#show" do
    it "has a show route" do
      get company_url(1)
      assert_response :success
      assert_select "h1", @first_company.name
    end
  end
end
