class User < ApplicationRecord
  before_save :set_admin
  before_update :set_admin

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :created_batches, class_name: 'Batch', foreign_key: 'batch_id'
  has_many :approved_batches, class_name: 'Batch', foreign_key: 'batch_id'
  has_many :bids

  validates :name, :cpf, presence: true
  validates :cpf, uniqueness: true
  validates :cpf, length: { is: 11 }

  private

  def set_admin
    if /\A[^@\s]+@leilaodogalpao.com.br\z/.match?(email)
      self.admin = true
    else
      self.admin = false
    end
  end
end
