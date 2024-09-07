require "test_helper"

class GamesControllerTest < ActionDispatch::IntegrationTest
  before do
    @game1 = Game.create!(id: 1, name: "Game 1", storyline: "some text", summary: "some more text", first_release_date: 809308800)
    @game2 = Game.create!(id: 2, name: "Game 2", storyline: "some text 2", summary: "some more text 2", first_release_date: 809308801)
  end

  describe "index" do
    it "can show the index page" do
      get games_url
      assert_response :success
    end

    it "can show an individual game" do
      get games_url(1)
      assert_response :success
      assert_select "h1", @game1.name
    end
  end
end
