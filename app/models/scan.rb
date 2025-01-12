class Scan < ApplicationRecord
    # belongs_to :users
    attribute :scan_result, :json
end
