class Product < ApplicationRecord
  belongs_to :category
  belongs_to :batch

  validates :code, :name, presence: true
  validates :code, uniqueness: true
  validates :weight, :width, :height, :depth, numericality: { only_integer: true, greater_than: 0 }
end
