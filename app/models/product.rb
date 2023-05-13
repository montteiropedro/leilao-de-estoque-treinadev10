class Product < ApplicationRecord
  belongs_to :category, optional: true
  belongs_to :lot, optional: true
  has_one_attached :image

  before_validation :set_alphanumeric_code

  validates :code, :name, presence: true
  validates :code, uniqueness: true
  validates :code, length: { is: 10 }
  validates :weight, :width, :height, :depth, numericality: { only_integer: true, greater_than: 0 }

  private

  def set_alphanumeric_code
    self.code = SecureRandom.alphanumeric(10).upcase if self.code.nil?
  end
end
