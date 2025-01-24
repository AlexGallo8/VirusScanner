class AddVtIdToScans < ActiveRecord::Migration[7.0]
  def change
    add_column :scans, :vt_id, :string
  end
end