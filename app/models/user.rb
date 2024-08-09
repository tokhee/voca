class User < ApplicationRecord
  has_secure_password
  validates :password, presence: true
  has_many :quizzes
  has_many :questions, through: :quizzes
  has_many :words
  has_many :tags
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates_format_of :email, with: URI::MailTo::EMAIL_REGEXP

  def self.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def self.encrypt(token)
    Digest::SHA256.hexdigest(token.to_s)
  end

  def update_correct_rate
    total_questions = questions.count
    correct_answers = questions.joins(:word).where('questions.user_answer = words.mean').count
    self.correct_rate = total_questions > 0 ? (correct_answers.to_f / total_questions) * 100 : 0.0
    save
    Rails.logger.debug "User #{id}: Correct rate updated to #{correct_rate}"
  end

  def update_rankings
    all_scores = User.joins(:quizzes).pluck('quizzes.score').compact
    user_score = self.score || 0
    self.highest_rate = (all_scores.count { |score| score > user_score }.to_f / all_scores.size * 100).round(2)
    save
    Rails.logger.debug "User #{id}: Highest rate updated to #{highest_rate}"
  end

  def update_user_score_and_rankings
    self.score = quizzes.sum(:score)
    save
    Rails.logger.debug "User #{id}: Total score updated to #{score}"
    update_correct_rate
    update_rankings
  end
end
