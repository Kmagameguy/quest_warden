class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  helper_method :current_user

  def current_user
    @current_user ||= session[:user_id] && User.find_by(id: session[:user_id])
  end

  def authenticate!
    if current_user.blank?
      flash[:alert] = "You are not authorized to access this resource."
      redirect_to new_user_session_path
    end
  end
end
