class RankingsController < ApplicationController
  def index
    @users = User.order(correct_rate: :desc)
  end
end
