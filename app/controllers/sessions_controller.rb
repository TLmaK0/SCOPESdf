class SessionsController < Devise::SessionsController
  # http://blog.andrewray.me/how-to-set-up-devise-ajax-authentication-with-rails-4-0/
  respond_to :json

  after_action :remove_notice

  private

  def remove_notice
    flash[:notice] = nil
  end

end