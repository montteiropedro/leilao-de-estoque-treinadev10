class Lot < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  belongs_to :approver, class_name: 'User', optional: true
  belongs_to :buyer, class_name: 'User', optional: true
  has_many :products, dependent: :nullify
  has_many :bids, dependent: nil
  has_many :users, through: :bids

  scope :in_progress, -> { where.not(approver: nil).and(where('start_date <= ? AND end_date >= ?', Date.current, Date.current)).order(created_at: :desc) }
  scope :waiting_start, -> { where.not(approver: nil).and(where('start_date > ?', Date.current)).order(created_at: :desc) }
  scope :awaiting_approval, -> { where(approver: nil).and(where('end_date >= ?', Date.current)).order(created_at: :desc) }
  scope :expired, -> { where('end_date < ?', Date.current).and(where(buyer: nil)).order(created_at: :desc) }
  scope :closed_expired, -> { where('end_date < ?', Date.current).and(where.not(buyer: nil)).order(created_at: :desc) }

  validates :code, :start_date, :end_date, :min_bid_in_centavos, :min_diff_between_bids_in_centavos, presence: true
  validates :code, uniqueness: true
  validates :code, format: { with: /\A[A-Z]{3}[0-9]{6}\z/, message: 'deve iniciar com 3 letras maiúsculas e terminar com 6 números' }
  validates :start_date, comparison: { greater_than_or_equal_to: Date.today, message: 'não pode estar no passado' }
  validates :end_date, comparison: { greater_than: :start_date, message: 'deve ser depois da data de início' }
  validates :min_bid_in_centavos, :min_diff_between_bids_in_centavos, numericality: { only_integer: true, greater_than: 0, message: 'deve ser um valor inteiro e positivo' }
  validate :valid_approver?

  def description
    "Lote #{code}"
  end

  def creator_description
    "#{creator.name} <#{creator.email}>"
  end

  def waiting_start?
    return true if Date.current < start_date

    false
  end

  def in_progress?
    return true if (Date.current >= start_date) && (Date.current <= end_date)

    false
  end

  def expired?
    return true if Date.current > end_date

    false
  end

  def sold?
    return true if expired? && buyer.present?

    false
  end

  def self.generate_code_suggestion
    random_string = Array.new(3) { ('A'..'Z').to_a.shuffle.sample }.join
    random_number_string = Array.new(6) { rand(1..9) }.join

    random_string + random_number_string
  end

  private

  def valid_approver?
    return if approver.blank?
    return errors.add(:approver, 'apenas administradores podem aprovar um lote') if approver.is_admin == false
    return errors.add(:approver, 'não pode aprovar um lote criado por si mesmo') if approver == creator
  end
end
