# frozen_string_literal: true
class UsersController < ApplicationController
  skip_before_action :require_sign_in!, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash.now[:alert] ='Successfully signed up!'
      render action: root_path
    else
      flash.now[:alert] ='FAil!'
      render :form
    end
  end


  private
  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :highest_rate)
  end
end
