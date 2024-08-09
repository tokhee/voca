class Quiz < ApplicationRecord
  belongs_to :user
  has_many :questions, dependent: :destroy
  has_many :user_answers, through: :questions
  belongs_to :current_question, class_name: 'Question', optional: true

  def current_question
    questions.order(:question_order).find_by(id: current_question_id)
  end

  def update_current_question(question)
    next_question = questions.where('question_order > ?', question.question_order).order(:question_order).first
    self.update(current_question_id: next_question&.id)
  end

  def previous_question(current_question)
    questions.where('question_order < ?', current_question.question_order).order(:question_order).last
  end

  def next_question(current_question)
    questions.where('question_order > ?', current_question.question_order).order(:question_order).first
  end

  def calculate_score
    self.score = questions.select(&:correct?).count
    save
  end

  def self.calculate_user_correct_rate(user)
    total_questions = joins(:questions).where(user: user).count
    correct_answers = joins(questions: :word).where(user: user).where('questions.user_answer = words.mean').count
    total_questions > 0 ? (correct_answers.to_f / total_questions) * 100 : 0.0
  end

  private

  def update_user_score
    user.update_user_score_and_rankings
  end
end



# class Quiz < ApplicationRecord
#   belongs_to :user
#   has_many :questions, dependent: :destroy
#   has_many :user_answers, through: :questions
#   belongs_to :current_question, class_name: 'Question', optional: true
#
#   def current_question
#     questions.order(:question_order).find_by(id: current_question_id)
#   end
#
#   def update_current_question(question)
#     next_question = questions.where('question_order > ?', question.question_order).order(:question_order).first
#     self.update(current_question_id: next_question&.id)
#   end
#
#   def previous_question(current_question)
#     questions.where('question_order < ?', current_question.question_order).order(:question_order).last
#   end
#
#   def next_question(current_question)
#     questions.where('question_order > ?', current_question.question_order).order(:question_order).first
#   end
#
#   def calculate_score
#     self.score = questions.select(&:correct?).count
#     save
#   end
#
#   def self.calculate_user_correct_rate(user)
#     total_questions = joins(:questions).where(user: user).count
#     correct_answers = joins(questions: :word).where(user: user).where('questions.user_answer = words.mean').count
#     total_questions > 0 ? (correct_answers.to_f / total_questions) * 100 : 0.0
#   end
#
#   private
#
#   def update_user_score
#     user.update_user_score_and_rankings
#   end
# end
