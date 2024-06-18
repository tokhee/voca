# db/migrate/[timestamp]_add_user_answer_to_questions.rb
class AddUserAnswerToQuestions < ActiveRecord::Migration[7.0]
  def change
    add_column :questions, :user_answer, :string
  end
end
