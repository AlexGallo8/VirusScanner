class AddVtIdToScans < ActiveRecord::Migration[7.1]
  def change
    add_column :scans, :vt_id, :string
  end
end
