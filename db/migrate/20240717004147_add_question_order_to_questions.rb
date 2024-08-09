class AddQuestionOrderToQuestions < ActiveRecord::Migration[7.1]
  def change
    add_column :questions, :question_order, :integer
  end
end
