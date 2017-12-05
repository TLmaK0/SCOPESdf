require "turbolinks/redirection"

class ApplicationController < ActionController::Base

  # Include turbolinks redirection methods
	include Turbolinks::Redirection

  protect_from_forgery prepend: true, with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized


  protected

    def configure_permitted_parameters
			devise_parameter_sanitizer.permit(:sign_up) do |user_params|
		    user_params.permit :email, :password, :password_confirmation, :name,
				 									 :avatar, :avatar_cache, :address_line1, :locality, :post_code,
												   :country, :bio, :lonlat, social: []
		  end
      devise_parameter_sanitizer.permit(:account_update, keys: [:name])
    end

		def set_lesson
      @lesson_obj = Lesson.find_by_id(params[:lesson_id])
    end

  private

  def user_not_authorized
    flash[:alert] = "Access denied."
    redirect_to (request.referrer || root_path)
  end

end
