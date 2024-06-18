class RankingsController < ApplicationController
  def index
    @users = User.order(correct_rate: :desc).limit(10)
  end
end
