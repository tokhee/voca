class Tag < ApplicationRecord

    has_and_belongs_to_many :words, dependent: :destroy
    validates :name, presence: true

end
