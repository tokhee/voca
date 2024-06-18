class AddWordIdAndQuizIdToQuestions < ActiveRecord::Migration[7.1]
  def change
    add_reference :questions, :word, null: false, foreign_key: true
  end
end
