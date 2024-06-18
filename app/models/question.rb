class Question < ApplicationRecord
  # Question은 Quiz 및 Word와 연관
  belongs_to :quiz
  belongs_to :word
  has_many :user_answers, dependent: :destroy

  # answered 필드에 true 또는 false만 허용
  validates :answered, inclusion: { in: [true, false] }
  # user_answer 필드가 존재해야 함. (nil 허용)
  validates :user_answer, presence: true, allow_nil: true

  # 사용자의 답변이 정답인지 확인하는 메서드
  def correct?
    user_answer.to_s.strip.downcase == word.mean.strip.downcase
  end
end
