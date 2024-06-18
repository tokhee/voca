class AddCorrectAnswerToWords < ActiveRecord::Migration[6.1]
  def change
    add_column :words, :correct_answer, :string
  end
end
