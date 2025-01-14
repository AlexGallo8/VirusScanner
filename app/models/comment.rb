class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :scan
  validates :content, presence: true
end
