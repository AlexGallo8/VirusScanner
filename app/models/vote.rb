class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :scan
  
  validates :vote_type, inclusion: { in: ['up', 'down'] }
  validates :user_id, uniqueness: { scope: :scan_id, message: "has already voted on this scan" }
end
