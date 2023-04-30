class Product < ApplicationRecord
  belongs_to :category
  belongs_to :batch
end
