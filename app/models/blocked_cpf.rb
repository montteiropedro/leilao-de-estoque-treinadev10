class BlockedCpf < ApplicationRecord
  validates :cpf, presence: true
  validates :cpf, uniqueness: true
  validates :cpf, length: { is: 11 }
  validates :cpf, cpf: true
end
