class Scan < ApplicationRecord
    belongs_to :user, optional: true  # Changed from :users to :user
    has_many :scan_users
    has_many :users, through: :scan_users

    has_many :votes, dependent: :destroy
    has_many :voting_users, through: :votes, source: :user

    has_many :comments, dependent: :destroy
    attribute :scan_result, :json

    validates :hashcode, presence: true, uniqueness: true
end
