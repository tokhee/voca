class AddSimilarAndTagToWords < ActiveRecord::Migration[7.1]
  def change
    add_reference :words, :similar, foreign_key: { to_table: :similars }
    add_reference :words, :tag, foreign_key: { to_table: :tags }
  end
end
