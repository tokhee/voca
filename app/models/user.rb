class User < ApplicationRecord
    has_secure_password
    validates :password, presence: true

    has_many :words
    has_many :tags
    has_many :quizzes
    validates :username, presence: true, uniqueness: true
    validates :email, presence: true, uniqueness: true

    validates_format_of :email, with: URI::MailTo::EMAIL_REGEXP

end
