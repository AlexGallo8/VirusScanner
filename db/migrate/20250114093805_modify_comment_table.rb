class ModifyCommentTable < ActiveRecord::Migration[7.1]
  def change
    add_column :comments, :scan_id, :integer

    add_index :comments, :scan_id
  end
end
