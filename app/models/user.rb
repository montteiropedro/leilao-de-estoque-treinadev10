class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :created_batches, class_name: 'Batch', foreign_key: 'batch_id'
  has_many :approved_batches, class_name: 'Batch', foreign_key: 'batch_id'
  has_many :bids

  before_validation :set_admin

  validates :name, :cpf, presence: true
  validates :cpf, uniqueness: true
  validates :cpf, length: { is: 11 }

  def can_make_a_bid?
    self.is_admin ? false : true
  end

  private

  def set_admin
    if /\A[^@\s]+@leilaodogalpao.com.br\z/.match?(email)
      self.is_admin = true
    else
      self.is_admin = false
    end
  end
end
