class RemoveGoogleFieldsFromUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :google_token
    remove_column :users, :google_refresh_token
    remove_column :users, :google_token_expires_at
  end
end
