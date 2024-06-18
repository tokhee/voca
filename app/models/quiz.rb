class Quiz < ApplicationRecord
  # Quiz는 User와 연관
  # 여러 Question을 가질 수 있음
  belongs_to :user
  has_many :questions, dependent: :destroy
  has_many :user_answers, through: :questions

  # 퀴즈의 점수를 계산하고 저장하는 메서드
  def calculate_score
    self.score = questions.select(&:correct?).count
    save
  end
end
