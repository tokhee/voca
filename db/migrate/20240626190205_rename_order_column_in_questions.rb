class RenameOrderColumnInQuestions < ActiveRecord::Migration[7.1]
  def change
    rename_column :questions, :order, :question_order
  end
end
