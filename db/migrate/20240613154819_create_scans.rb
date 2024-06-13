class CreateScans < ActiveRecord::Migration[7.1]
  def change
    create_table :scans do |t|
      t.string 'file_name'
      t.string 'file_type'
      t.string 'hashcode'
      t.integer 'file_size'
      t.datetime 'upload_date'
      t.integer 'vote_up', default:0
      t.integer 'vote_down', default:0
      t.timestamps
    end
  end
end
