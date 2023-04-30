class Batch < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  belongs_to :approver, class_name: 'User'

  validates :code, :start_date, :end_date, :minimum_bid, :minimum_difference_between_bids, presence: true
  validates :start_date, comparison: { less_than: end_date }
  validates :minimum_bid, :minimum_difference_between_bids, numericality: { only_integer: true }
end
