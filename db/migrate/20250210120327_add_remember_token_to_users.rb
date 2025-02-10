class AddRememberTokenToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :remember_token, :string
    add_index :users, :remember_token
    add_column :users, :remember_token_expires_at, :datetime
  end
end
