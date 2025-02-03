class CreateVotes < ActiveRecord::Migration[7.1]
  def change
    create_table :votes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :scan, null: false, foreign_key: true
      t.string :vote_type

      t.timestamps
    end

    add_index :votes, [:user_id, :scan_id], unique: true
  end
end
