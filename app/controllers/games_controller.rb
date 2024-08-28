class GamesController < ApplicationController
  def index
    @games = Game.includes(:platforms).all
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
