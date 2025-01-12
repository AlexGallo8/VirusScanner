class ModifyUsersTable < ActiveRecord::Migration[7.1]
  def change
    remove_index :users, :clerk_id
    remove_column :users, :clerk_id

    add_column :users, :auth_provider, :string
    add_column :users, :auth0_uid, :string

    add_index :users, :auth0_uid, unique: true
  end
end