class CreateJoinTableWordsTags < ActiveRecord::Migration[6.1]
  def change
    create_join_table :words, :tags do |t|
      t.index :word_id
      t.index :tag_id
    end
  end
end
