class CreateTagsWordsJoinTable < ActiveRecord::Migration[6.1]
  def change
    create_table :tags_words, id: false do |t|
      t.belongs_to :tag
      t.belongs_to :word
    end

    add_index :tags_words, [:tag_id, :word_id], unique: true
  end
end