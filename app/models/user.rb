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
  has_and_belongs_to_many :favorite_lots, class_name: 'Lot'

  before_validation :set_admin

  validates :name, :cpf, presence: true
  validates :email, format: { with: /\A[^@\s]+@[^@\s]+\z/ }
  validates :cpf, uniqueness: true
  validates :cpf, length: { is: 11 }
  validates :cpf, cpf: true

  def can_make_a_bid?
    self.is_admin ? false : true
  end

  private

  def set_admin
    return self.is_admin = true if /\A[^@\s]+@leilaodogalpao.com.br\z/.match?(email)
    
    self.is_admin = false
  end
end
