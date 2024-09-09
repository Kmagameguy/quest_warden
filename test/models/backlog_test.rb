require "test_helper"

class BacklogTest < ActiveSupport::TestCase
  before do
    @user = User.build(id: 1, name: "John Doe", password: "password", password_confirmation: "password")
    @backlog = @user.build_backlog
    @game = Game.create!(id: 1, name: "My Game", storyline: "this is a storyline", summary: "this is a summary", first_release_date: 809308800)
  end

  it "should belong to a user" do
    assert_respond_to @backlog, :user
  end

  it "should have many games" do
    assert_respond_to @backlog, :games
  end

  it "should be valid with a user" do
    backlog2 = Backlog.build(user: @user)
    assert backlog2.valid?
  end

  it "should be invalid without a user" do
    @backlog.user = nil
    assert_not @backlog.valid?
    assert_includes @backlog.errors[:user], "must exist"
  end

  it "should accept game additions" do
    @backlog.games << @game
    assert_includes @backlog.games, @game
  end

  it "should allow game removals" do
    @backlog.games << @game
    @backlog.games.delete(@game)
    assert_not_includes @backlog.games, @game
  end
end
