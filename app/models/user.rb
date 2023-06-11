class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :created_lots, class_name: 'Lot', foreign_key: 'creator_id', dependent: nil
  has_many :approved_lots, class_name: 'Lot', foreign_key: 'approver_id', dependent: nil
  has_many :won_lots, class_name: 'Lot', foreign_key: 'buyer_id', dependent: nil
  has_many :bids, dependent: nil
  has_many :lots, through: :bids, dependent: nil
  has_and_belongs_to_many :favorite_lots, class_name: 'Lot', dependent: nil

  before_validation :set_admin

  validates :name, :cpf, presence: true
  validates :email, format: { with: /\A[^@\s]+@[^@\s]+\z/ }
  validates :cpf, uniqueness: true
  validates :cpf, length: { is: 11 }
  validates :cpf, cpf: true

  def can_make_bid?
    return false if is_admin

    true
  end

  def cpf_blocked?
    return true if BlockedCpf.find_by(cpf:)

    false
  end

  private

  def set_admin
    return self.is_admin = true if /\A[^@\s]+@leilaodogalpao.com.br\z/.match?(email)

    self.is_admin = false
  end
end
