class AddScoreToQuizzes < ActiveRecord::Migration[7.0]
  def change
    add_column :quizzes, :score, :integer, default: 0
  end
end
