class ApplicationController < ActionController::Base
  before_action :require_sign_in!

  protect_from_forgery with: :exception

  helper_method :current_user

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def sign_in(user)
    session[:user_id] = user.id
    @current_user = user
  end

  def sign_out
    session.delete(:user_id)
    @current_user = nil
  end

  def signed_in?
    current_user.present?
  end

  private

  def require_sign_in!
    redirect_to login_path unless signed_in?
  end
end
