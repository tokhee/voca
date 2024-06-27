class User < ApplicationRecord
    has_secure_password
    validates :password, presence: true, length: { minimum: 1, maximum: 8 }

    has_many :words, dependent: :destroy
    has_many :quizzes, dependent: :destroy
    has_many :tags, dependent: :destroy

    validates :username, presence: true, uniqueness: true
    validates :email, presence: true, uniqueness: true
    validates_format_of :email, with: URI::MailTo::EMAIL_REGEXP

    def update_correct_rate
        total_questions = quizzes.joins(:questions).count
        correct_answers = quizzes.joins(:questions).where(questions: { correct: true }).count
        self.correct_rate = total_questions > 0 ? (correct_answers.to_f / total_questions * 100).round(2) : 0
        update_column(:correct_rate, self.correct_rate)  # 유효성 검사를 건너뛰고 correct_rate 업데이트
    end
end
