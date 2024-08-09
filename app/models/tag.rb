class Tag < ApplicationRecord

    has_many :taggings
    has_many :words, through: :taggings

    has_and_belongs_to_many :words, dependent: :destroy
    validates :name, presence: true
    belongs_to :user

end
