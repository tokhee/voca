class WordSimilarity < ApplicationRecord
  belongs_to :word
  belongs_to :similar
end
