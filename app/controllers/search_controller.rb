class SearchController < ApplicationController
  before_action :check_query, only: :index
  def index
    if sanitized_query.present?
      @games = IgdbService.instance.game_search(sanitized_query)
    else
      @games = Game.none
    end
  end

  private

  def check_query
    if sanitized_query.blank?
      flash[:alert] = "You must provide a search query."
      redirect_to root_path
    end
  end

  def sanitized_query
    if params[:query].present?
      ActiveRecord::Base.sanitize_sql_like(params[:query])
    end
  end
end
