class Batch < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  belongs_to :approver, class_name: 'User', optional: true

  validates :code, :start_date, :end_date, :minimum_bid, :minimum_difference_between_bids, presence: true
  validates :code, uniqueness: true
  validates :code, format: { with: /\A[A-Z]{3}[0-9]{6}\z/, message: 'deve iniciar com 3 letras maiúsculas e terminar com 6 números' }
  validates :start_date, comparison: { greater_than_or_equal_to: Date.today, message: 'não pode estar no passado' }
  validates :end_date, comparison: { greater_than: :start_date, message: 'deve ser depois da data de início' }
  validates :minimum_bid, :minimum_difference_between_bids, numericality: { only_integer: true, greater_than: 0, message: 'deve ser um valor inteiro e positivo' }

  def get_creator_description
    "#{self.creator.name} <#{self.creator.email}>"
  end

  def self.generate_code_suggestion
    random_string = Array.new(3) { ('A'..'Z').to_a.shuffle.sample }.join
    random_number_string = Array.new(6) { rand(1..9) }.join
    
    random_string + random_number_string
  end
end
