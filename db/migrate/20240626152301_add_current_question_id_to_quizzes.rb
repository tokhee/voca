class AddCurrentQuestionIdToQuizzes < ActiveRecord::Migration[7.1]
  def change
    add_column :quizzes, :current_question_id, :integer
  end
end
