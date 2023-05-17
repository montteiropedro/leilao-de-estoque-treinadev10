class Product < ApplicationRecord
  belongs_to :category, optional: true
  belongs_to :lot, optional: true
  has_one_attached :image

  enum status: { available: 0, unavailable: 1, sold: 2 }

  before_validation :set_alphanumeric_code, on: :create
  before_validation :set_status, on: :create

  validates :code, :name, presence: true
  validates :code, uniqueness: true
  validates :code, length: { is: 10 }
  validates :weight, :width, :height, :depth, numericality: { only_integer: true, greater_than: 0 }
  validate :is_status_valid?

  private

  def set_alphanumeric_code
    self.code = SecureRandom.alphanumeric(10).upcase if self.code.nil?
  end

  def set_status
    return self.status = 2 if self.lot.present? && self.lot.buyer.present?
    return self.status = 1 if self.lot.present? && self.lot.buyer.blank?

    self.status = 0
  end

  def is_status_valid?
    if self.status == 0 && self.lot.present?
      return errors.add(:status, 'só pode ser "disponível" quando não pertencer a um lote')

    elsif self.status == 1 && self.lot.blank?
      errors.add(:status, 'só pode ser "indisponível" quando pertencer a um lote que não possui um comprador')

    elsif self.status == 2 && (self.lot.blank? || self.lot.buyer.blank?)
      errors.add(:status, 'só pode ser "vendido" quando pertencer a um lote que possui um comprador')
    end
  end
end
