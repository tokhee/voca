class SessionsController < ApplicationController
  skip_before_action :require_sign_in!, only: [:new, :create]
  before_action :set_user, only: [:create]

  def create
    if @user&.authenticate(params[:session][:password])
      sign_in(@user)
      redirect_to main_menu_path
    else
      flash.now[:danger] = 'Eメール/パスワードの組み合わせが無効です'
      render :new
    end
  end


  def destroy
    sign_out
    redirect_to login_path
  end

  private

  def set_user
    @user = User.find_by(email: params[:session][:email].downcase)
  end
end
