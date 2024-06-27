class Tag < ApplicationRecord
    belongs_to :user
    has_and_belongs_to_many :words, dependent: :destroy
    validates :name, presence: true

end
