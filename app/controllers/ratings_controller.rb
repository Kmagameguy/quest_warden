class RatingsController < ApplicationController
  before_action :find_rateable

  def create
    @rating = @rateable.ratings.find_or_initialize_by(user: current_user)
    @rating.value = rating_params[:value]

    if @rating.save
      flash[:notice] = "Rating successfully submitted."
      redirect_to @rateable
    else
      flash[:alert] = "There was an error submitting your rating."
      render :new
    end
  end

  def update
    @rating = @rateable.ratings.find_or_intialize_by(user: current_user)
    @rating.value = rating_params[:value]

    if @rating.save
      flash[:notice] = "Rating succesfully updated."
      redirect_to @rateable
    else
      flash[:alert] = "There was an error updating your rating."
      render :edit
    end
  end

  private

  def find_rateable
    @rateable = params.dig(:rating, :rateable_type).constantize.find(params.dig(:rating, :rateable_id))
  end

  def rating_params
    params.require(:rating).permit(:value)
  end
end
