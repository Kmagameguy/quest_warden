class BacklogsController < ApplicationController
  before_action :set_user
  before_action :set_game, except: %i[ show ]
  before_action :set_backlog
  def show; end

  def add_game
    if @user.backlog.games.exclude?(@game)
      @backlog.games << @game unless @user.backlog.games.include?(@game)
      flash[:notice] = "#{@game.name} was added to your backlog."
    else
      flash[:alert] = "#{@game.name} is already in your backlog!"
    end

    redirect_to game_path(@game)
  end

  def remove_game
    @backlog.games.delete(@game)
    flash[:alert] = "#{@game.name} was removed from your backlog."
    redirect_to game_path(@game)
  end

  private

  def set_user
    @user = current_user
  end

  def set_game
    @game = Game.find(params[:game_id])
  end

  def set_backlog
    @backlog = @user.backlog
  end
end
