class CreateUserAnswers < ActiveRecord::Migration[6.0]
  def change
    create_table :user_answers do |t|
      t.references :user, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.string :answer
      t.boolean :correct, default: false

      t.timestamps
    end
  end
end
