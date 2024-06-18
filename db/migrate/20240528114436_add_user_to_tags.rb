class AddUserToTags < ActiveRecord::Migration[7.1]
  def change
    add_reference :tags, :user, foreign_key: { to_table: :users }
  end
end
