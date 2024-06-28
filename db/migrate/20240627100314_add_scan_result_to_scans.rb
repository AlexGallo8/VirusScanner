class AddScanResultToScans < ActiveRecord::Migration[7.1]
  def change
    add_column :scans, :scan_result, :json
  end
end
