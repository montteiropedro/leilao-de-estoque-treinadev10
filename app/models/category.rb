class Category < ApplicationRecord
  has_many :products, dependent: nil

  validates :name, presence: true
  validates :name, uniqueness: true
end
