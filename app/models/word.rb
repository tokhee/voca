class Word < ApplicationRecord
  belongs_to :user
  has_many :similars, dependent: :destroy
  has_and_belongs_to_many :tags, optional: true, dependent: :destroy
  has_many :questions
  validates :title, presence: true
  validates :mean, presence: true
  accepts_nested_attributes_for :similars, allow_destroy: true
end
