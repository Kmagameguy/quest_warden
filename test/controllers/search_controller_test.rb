require "test_helper"

class SearchControllerTest < ActionDispatch::IntegrationTest
  before do
    @game = Game.create!(id: 1, name: "Game 1", storyline: "some story", summary: "some summary", first_release_date: 809308800)
    @query = "where id = #{@game.id};"
  end

  describe "index" do
    it "should redirect and set flash alert with an empty query" do
      get search_url
      assert_equal "You must provide a search query.", flash[:alert]
      assert_redirected_to root_path
    end

    it "should redirect and set flash alert with a blank query" do
      get search_url(query: " ")
      assert_equal "You must provide a search query.", flash[:alert]
      assert_redirected_to root_path
    end

    it "searches for a resource with query params" do
      IgdbService.instance.expects(:game_search).with(@query).once
      get search_url(query: @query)
      assert_response :success
    end
  end
end
