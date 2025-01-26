class ScanUser < ApplicationRecord
  belongs_to :user
  belongs_to :scan
end
