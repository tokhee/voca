# db/migrate/20240627071819_create_join_table_tags_words.rb
class CreateJoinTableTagsWords < ActiveRecord::Migration[6.0]
  def change
    create_join_table :tags, :words do |t|
      t.index [:tag_id, :word_id]
      t.index [:word_id, :tag_id]
    end
  end
end
