class UserStatsController < ApplicationController
  before_action :authenticate!

  def show
    @user = current_user
  end
end
