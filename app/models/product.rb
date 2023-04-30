class Product < ApplicationRecord
  belongs_to :category
  belongs_to :batch

  validates :code, :name, presence: true
  validates :code, uniqueness: true
end
