class Batch < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  belongs_to :approver, class_name: 'User', optional: true
  has_many :products, dependent: :nullify
  has_many :bids
  has_many :users, through: :bids

  validates :code, :start_date, :end_date, :min_bid_in_centavos, :min_diff_between_bids_in_centavos, presence: true
  validates :code, uniqueness: true
  validates :code, format: { with: /\A[A-Z]{3}[0-9]{6}\z/, message: 'deve iniciar com 3 letras maiúsculas e terminar com 6 números' }
  validates :start_date, comparison: { greater_than_or_equal_to: Date.today, message: 'não pode estar no passado' }
  validates :end_date, comparison: { greater_than: :start_date, message: 'deve ser depois da data de início' }
  validates :min_bid_in_centavos, :min_diff_between_bids_in_centavos, numericality: { only_integer: true, greater_than: 0, message: 'deve ser um valor inteiro e positivo' }
  validate :approver_is_valid?

  def get_description
    "Lote #{self.code}"
  end

  def get_creator_description
    "#{self.creator.name} <#{self.creator.email}>"
  end

  def waiting_start?
    return true if Date.today < self.start_date

    false
  end

  def in_progress?
    return true if (Date.today >= self.start_date) && (Date.today <= self.end_date)

    false
  end

  def expired?
    return true if Date.today > self.end_date

    false
  end

  def self.generate_code_suggestion
    random_string = Array.new(3) { ('A'..'Z').to_a.shuffle.sample }.join
    random_number_string = Array.new(6) { rand(1..9) }.join
    
    random_string + random_number_string
  end

  private

  def approver_is_valid?
    return if self.approver.blank?

    if self.approver.is_admin == false
      errors.add(:approver, 'apenas administradores podem aprovar um lote')
    end

    if self.approver == self.creator
      errors.add(:approver, 'não pode aprovar um lote criado por si mesmo')
    end
  end
end
