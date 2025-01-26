class Scan < ApplicationRecord
    belongs_to :users, optional: true
    has_many :scan_users
    has_many :users, through: :scan_users


    has_many :comments
    attribute :scan_result, :json

    validates :hashcode, presence: true, uniqueness: true
end
