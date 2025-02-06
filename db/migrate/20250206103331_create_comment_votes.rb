class CreateCommentVotes < ActiveRecord::Migration[7.1]
  def change
    create_table :comment_votes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :comment, null: false, foreign_key: true
      t.string :vote_type

      t.timestamps
    end

    # You can only vote once per comment
    add_index :comment_votes, [:user_id, :comment_id], unique: true

    # Counter cache columns to comments
    add_column :comments, :likes_count, :integer, default: 0
    add_column :comments, :dislikes_count, :integer, default: 0
  end
end