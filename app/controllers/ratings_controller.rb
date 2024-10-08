class RatingsController < ApplicationController
  ALLOWED_RATEABLE_TYPES = { "Game" => Game }.freeze

  before_action :find_rateable
  before_action :find_or_initialize_rating

  def create
    if rating_params[:value].blank?
      flash.now[:alert] = "Rating cannot be blank."
      redirect_to @rateable
    else
      @rating.value = rating_params[:value]
      save_rating("Rating successfully submitted.", :create)
    end
  end

  def update
    if rating_params[:value].blank?
      destroy; return
    end

    @rating.value = rating_params[:value]
    save_rating("Rating successfully updated.", :update)
  end

  def destroy
    if @rating.destroy
      flash[:notice] = "Rating successfully removed."
    else
      flash[:alert] = "There was an error removing your rating."
    end

    redirect_to @rateable
  end

  private

  def find_or_initialize_rating
    @rating = Rating.find_or_initialize_by(rateable: @rateable, user: current_user)
  end

  def find_rateable
    type = rateable_type(params.dig(:rating, :rateable_type))
    rateable_id = params.dig(:rating, :rateable_id)

    if type
      @rateable = type.find(rateable_id)
    else
      flash[:alert] = "Invalid type specified."
      redirect_to @rateable
    end
  end

  def rating_params
    params.require(:rating).permit(:value, :rateable_type, :rateable_id)
  end

  def save_rating(success_message, render_action)
    if @rating.save
      remove_from_backlog(success_message)
    else
      flash[:alert] = failure_message(render_action)
    end

    redirect_to @rateable
  end

  def failure_message(render_action)
    "There was an error #{render_action == :create ? 'submitting' : 'updating'} your rating."
  end

  def rateable_type(type)
    ALLOWED_RATEABLE_TYPES[type]
  end

  def remove_from_backlog(message)
    if current_user.backlog.games.include?(@rateable)
      current_user.backlog.games.delete(@rateable)
      flash[:notice] = "Rating submitted and #{@rateable.name} was removed from backlog."
    else
      flash[:notice] = message
    end
  end
end
