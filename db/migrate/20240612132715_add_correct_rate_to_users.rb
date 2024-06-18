class AddCorrectRateToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :correct_rate, :float, default: 0.0
  end
end
