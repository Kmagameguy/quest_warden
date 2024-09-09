class RatingsController < ApplicationController
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
    @rateable = params.dig(:rating, :rateable_type).constantize.find(params.dig(:rating, :rateable_id))
  end

  def rating_params
    params.require(:rating).permit(:value, :rateable_type, :rateable_id)
  end

  def save_rating(success_message, render_action)
    if @rating.save
      flash[:notice] = success_message
    else
      flash[:alert] = failure_message(render_action)
    end

    redirect_to @rateable
  end

  def failure_message(render_action)
    "There was an error #{render_action == :create ? 'submitting' : 'updating'} your rating."
  end
end
