require 'rails_helper'

RSpec.describe BlockedCpf, type: :model do
  describe '#valid?' do
    describe 'cpf' do
      it 'não deve ser uma string vazia' do
        blocked_cpf = BlockedCpf.new(cpf: '')

        blocked_cpf.valid?

        expect(blocked_cpf.errors.include?(:cpf)).to eq true
        expect(blocked_cpf.errors[:cpf].include?('não pode ficar em branco')).to eq true
      end

      it 'deve ter tamanho igual a 11' do
        blocked_cpf = BlockedCpf.new(cpf: '417602')

        blocked_cpf.valid?

        expect(blocked_cpf.errors.include?(:cpf)).to eq true
        expect(blocked_cpf.errors[:cpf].include?('não possui o tamanho esperado (11 caracteres)')).to eq true
      end

      it 'deve ser um CPF válido' do
        blocked_cpf = BlockedCpf.new(cpf: '11122233300')

        blocked_cpf.valid?

        expect(blocked_cpf.errors.include?(:cpf)).to eq true
        expect(blocked_cpf.errors[:cpf].include?('não é válido')).to eq true
      end

      it 'deve ser único' do
        BlockedCpf.create!(cpf: '73046259026')
        blocked_cpf = BlockedCpf.new(cpf: '73046259026')

        blocked_cpf.valid?

        expect(blocked_cpf.errors.include?(:cpf)).to eq true
        expect(blocked_cpf.errors[:cpf].include?('já está em uso')).to eq true
      end
    end
  end
end
