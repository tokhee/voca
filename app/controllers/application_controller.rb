class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user

  def current_user
    return unless session[:user_id]
    @current_user ||= User.find(session[:user_id])
  end

  def require_login
    unless current_user
      redirect_to login_path, alert: "ログインが必要です。"
    end
  end
end
