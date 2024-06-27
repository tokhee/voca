class AddOrderToQuestions < ActiveRecord::Migration[7.0]
  def change
    add_column :questions, :order, :integer
    add_index :questions, [:quiz_id, :order], unique: true
  end
end
