class Comment < ApplicationRecord
  belongs_to :user, foreign_key: :user_id
  belongs_to :scan, foreign_key: :scan_id
  has_many :comment_votes, dependent: :destroy
  
  validates :content, presence: true

  def voted_by?(user)
    comment_votes.exists?(user: user)
  end

  def vote_type_by(user)
    comment_votes.find_by(user: user)&.vote_type
  end

  def likes_count
    comment_votes.where(vote_type: 'like').count
  end

  def dislikes_count
    comment_votes.where(vote_type: 'dislike').count
  end
end
