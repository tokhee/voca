class Quiz < ApplicationRecord
  belongs_to :user
  has_many :questions, dependent: :destroy
  def calculate_score
    correct_answers = questions.where(correct: true).count
    self.score = correct_answers
    save

    user.update_correct_rate
  end
  def current_question
    questions.find_by(id: current_question_id) || questions.order(:question_order).first
  end

  def next_question
    questions.where('question_order > ?', current_question&.question_order).order(:question_order).first
  end

  def previous_question
    questions.where('question_order < ?', current_question&.question_order).order(:question_order).last
  end

  def update_current_question(question)
    self.current_question_id = question.id
    save
  end
end
