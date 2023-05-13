class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :created_lots, class_name: 'Lot', foreign_key: 'creator_id'
  has_many :approved_lots, class_name: 'Lot', foreign_key: 'approver_id'
  has_many :won_lots, class_name: 'Lot', foreign_key: 'buyer_id'
  has_many :bids
  has_many :lots, through: :bids

  before_validation :set_admin

  validates :name, :cpf, presence: true
  validates :email, format: { with: /\A[^@\s]+@[^@\s]+\z/ }
  validates :cpf, uniqueness: true
  validates :cpf, length: { is: 11 }
  validate :cpf_is_valid?

  def can_make_a_bid?
    self.is_admin ? false : true
  end

  private

  def set_admin
    return self.is_admin = true if /\A[^@\s]+@leilaodogalpao.com.br\z/.match?(email)
    
    self.is_admin = false
  end

  DENY_LIST = %w[
    00000000000 11111111111 22222222222 33333333333 44444444444 55555555555
    66666666666 77777777777 88888888888 99999999999 12345678909 01234567890
  ].freeze

  def cpf_is_valid?
    return if self.cpf.blank?
    return errors.add(:cpf, 'não é válido') if DENY_LIST.include? self.cpf

    verifying_digit = ''
    verifying_digit << cpf_find_verifying_digits(digits: self.cpf[0..8], descending_sequence_from: 10).to_s
    verifying_digit << cpf_find_verifying_digits(digits: self.cpf[0..9], descending_sequence_from: 11).to_s
    
    errors.add(:cpf, 'não é válido') unless self.cpf[9..10] == verifying_digit
  end

  def cpf_find_verifying_digits(digits:, descending_sequence_from:)
    final_result = digits.chars.map(&:to_i).sum do |number|
      result = number * descending_sequence_from
      descending_sequence_from -= 1
      
      result
    end

    cpf_define_verifying_digit(11 - (final_result % 11))
  end

  def cpf_define_verifying_digit(number)
    return number if number < 10

    0
  end
end
