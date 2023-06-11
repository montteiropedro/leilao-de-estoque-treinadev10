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
  validate :valid_status?

  private

  def set_alphanumeric_code
    self.code = SecureRandom.alphanumeric(10).upcase if code.nil?
  end

  def set_status
    return self.status = 2 if lot.present? && lot.buyer.present?
    return self.status = 1 if lot.present? && lot.buyer.blank?

    self.status = 0
  end

  def valid_status?
    if status == 0 && lot.present?
      errors.add(:status, 'só pode ser "disponível" quando não pertencer a um lote')

    elsif status == 1 && lot.blank?
      errors.add(:status, 'só pode ser "indisponível" quando pertencer a um lote que não possui um comprador')

    elsif status == 2 && (lot.blank? || lot.buyer.blank?)
      errors.add(:status, 'só pode ser "vendido" quando pertencer a um lote que possui um comprador')
    end
  end
end
