# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :set_current_user

  def index

  end
  def new
  end

  def create
    if params[:session].present?
      @user = User.find_by(email: params[:session][:email].downcase)
      if @user&.authenticate(params[:session][:password])
        session[:user_id] = @user.id
        redirect_to main_menu_path(@user)
      else
        render :new
      end
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path
  end

  private

  def set_current_user
    if session[:user_id]
      @user = User.find_by(id: session[:user_id])
    end
  end

end
