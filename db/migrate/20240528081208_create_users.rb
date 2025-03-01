class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :username
      t.string :email, null: false
      t.string :password_digest
      t.integer :highest_rate
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
