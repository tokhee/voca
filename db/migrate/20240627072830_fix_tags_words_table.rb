class FixTagsWordsTable < ActiveRecord::Migration[6.0]
  def change
    drop_table :tags_words, if_exists: true

    create_table :tags_words, id: false do |t|
      t.bigint :tag_id
      t.bigint :word_id

      t.index [:tag_id, :word_id], unique: true
      t.index [:word_id, :tag_id], unique: true
    end
  end
end
