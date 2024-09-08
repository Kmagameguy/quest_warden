require "test_helper"

class UserTest < ActiveSupport::TestCase
  before do
    @valid_password = "secure_password"
    @user = User.new(
      id: 111,
      name: "Test User",
      password: @valid_password,
      password_confirmation: @valid_password
    )
  end

  describe "validations" do
    it "is valid with attributes" do
      _(@user).must_be :valid?
    end

    it "must have a name" do
      @user.name = nil

      _(@user).must_be :invalid?
      _(@user.errors[:name]).must_include "can't be blank"
    end

    it "must have a matching password confirmation" do
      @user.password_confirmation = "mismatch"

      _(@user).must_be :invalid?
      _(@user.errors[:password_confirmation]).must_include "doesn't match Password"
    end
  end

  describe "password authentication" do
    before do
      @user.save
    end

    it "will authenticate with a valid password" do
      authenticated_user = User.find_by(name: @user.name).authenticate(@valid_password)
      assert_equal @user, authenticated_user
    end

    it "will not authenticate with an invalid password" do
      authenticated_user = User.find_by(name: @user.name).authenticate("wrong_password")
      assert_not authenticated_user
    end
  end
end
