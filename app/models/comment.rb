class Comment < ApplicationRecord
  belongs_to :user, foreign_key: :user_id
  belongs_to :scan, foreign_key: :scan_id
  validates :content, presence: true
end
