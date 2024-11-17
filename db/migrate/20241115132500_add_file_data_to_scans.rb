class AddFileDataToScans < ActiveRecord::Migration[7.1]
    def change
      add_column :scans, :file_data, :text
    end
  end