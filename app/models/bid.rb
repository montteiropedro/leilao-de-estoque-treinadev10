class Bid < ApplicationRecord
  belongs_to :user
  belongs_to :batch

  validates :value_in_centavos, presence: true
  validates :value_in_centavos, numericality: { only_integer: true, greater_than: 0 }
end
