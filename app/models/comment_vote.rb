class CommentVote < ApplicationRecord
  belongs_to :user
  belongs_to :comment

  validates :vote_type, presence: true, inclusion: { in: ['like', 'dislike'] }
  validates :user_id, uniqueness: { scope: :comment_id }

  after_save :update_counter_cache
  after_destroy :update_counter_cache

  private

  def update_counter_cache
    likes = comment.comment_votes.where(vote_type: 'like').count
    dislikes = comment.comment_votes.where(vote_type: 'dislike').count
    
    comment.update_columns(
      likes_count: likes,
      dislikes_count: dislikes
    )
  end
end