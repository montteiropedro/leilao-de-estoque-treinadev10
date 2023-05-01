class Bid < ApplicationRecord
  belongs_to :user
  belongs_to :batch

  validates :value, presence: true
  validates :value, numericality: { only_integer: true, greater_than: 0 }
end
