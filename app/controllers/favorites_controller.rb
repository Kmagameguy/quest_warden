class FavoritesController < ApplicationController
  before_action :authenticate!
  before_action :find_favoritable

  def create
    @favorite = Favorite.new(favoritable: @favoritable, user: current_user)
    if @favorite.save
      flash[:notice] = "#{@favoritable.name} added to favorites!"
      redirect_to @favoritable
    else
      flash[:alert] = "#{@favoritable.name} couldn't be added to favorites."
      redirect_do @favoritable
    end
  end

  def destroy
    @favorite = Favorite.find_by(favoritable: @favoritable, user: current_user)

    if @favorite.present? && @favorite.destroy
      flash[:notice] = "#{@favoritable.name} removed from favorites!"
      @favorite.destroy
    else
      flash[:alert] = "Couldn't remove from favorites."
    end

    redirect_to @favoritable
  end

  private

  def find_favoritable
    @favoritable = Game.find(params[:game_id])
  end
end
