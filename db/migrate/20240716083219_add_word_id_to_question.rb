class AddWordIdToQuestion < ActiveRecord::Migration[7.1]
  def change
    add_column :questions, :word_id, :integer
  end
end
