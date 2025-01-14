class ModifyScanTable < ActiveRecord::Migration[7.1]
  def change
    add_column :scans, :user_id, :integer

    add_index :scans, :user_id
  end
end
