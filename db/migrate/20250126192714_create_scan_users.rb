class CreateScanUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :scan_users do |t|
      t.references :user, null: false, foreign_key: true
      t.references :scan, null: false, foreign_key: true

      t.timestamps
    end
  end
end
