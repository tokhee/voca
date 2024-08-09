# frozen_string_literal: true

class Similar < ApplicationRecord
  belongs_to :word
  # validates :similar, presence: true

end
