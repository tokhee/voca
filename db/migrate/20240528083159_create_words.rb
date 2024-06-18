class CreateWords < ActiveRecord::Migration[7.1]
  def change
    create_table :words do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.text :mean, null: false

      t.timestamps
    end
  end
end
