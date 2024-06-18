class CreateSimilars < ActiveRecord::Migration[7.1]
  def change
    create_table :similars do |t|
      t.references :word, null: false, foreign_key: true
      t.string :similar

      t.timestamps
    end
  end
end
