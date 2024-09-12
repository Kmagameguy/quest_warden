class GamesController < ApplicationController
  def index
    @letter = params[:letter]

    if @letter
      @games = Game.includes(:platforms, :genres).where("name LIKE ?", "#{@letter}%")
    else
      @games = Game.includes(:platforms, :genres).all
    end
  end

  def show
    @game = Game.find_by(id: params[:id])

    if @game.nil?
      ActiveRecord::Base.transaction do
        ::Importers::Game.new.import_by_id(params[:id])
        @game = Game.find(params[:id])
      end
    end
  end
end
