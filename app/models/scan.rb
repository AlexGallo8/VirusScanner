class Scan < ApplicationRecord
    belongs_to :users
    has_many :comments
    attribute :scan_result, :json
end
