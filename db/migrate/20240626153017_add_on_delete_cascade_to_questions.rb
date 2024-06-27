class AddOnDeleteCascadeToQuestions < ActiveRecord::Migration[6.0]
  def change
    remove_foreign_key :questions, :quizzes
    add_foreign_key :questions, :quizzes, on_delete: :cascade
  end
end
