class RankingsController < ApplicationController
  def index
    @users = User.all
    @user_correct_rates = @users.map do |user|
      {
        user: user,
        correct_rate: Quiz.calculate_user_correct_rate(user)
      }
    end.sort_by { |data| -data[:correct_rate] }
  end

  private

  def require_login
    redirect_to login_path unless session[:user_id]
  end
end
