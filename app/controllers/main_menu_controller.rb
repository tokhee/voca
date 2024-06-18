class MainMenuController < ApplicationController
  before_action :require_login

  def index

  end

  def home

  end

  def require_login
    redirect_to login_path unless session[:user_id]
  end

end
