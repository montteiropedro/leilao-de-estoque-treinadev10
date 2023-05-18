require 'rails_helper'

RSpec.describe BlockedCpf, type: :model do
  describe '#valid?' do
    describe 'cpf' do
      it 'should not be empty' do
        blocked_cpf = BlockedCpf.new(cpf: '')
  
        blocked_cpf.valid?
  
        expect(blocked_cpf.errors.include? :cpf).to eq true
        expect(blocked_cpf.errors[:cpf].include? 'não pode ficar em branco').to eq true
      end
  
      it 'should have size equal to 11' do
        blocked_cpf = BlockedCpf.new(cpf: '417602')
  
        blocked_cpf.valid?
  
        expect(blocked_cpf.errors.include? :cpf).to eq true
        expect(blocked_cpf.errors[:cpf].include? 'não possui o tamanho esperado (11 caracteres)').to eq true
      end
  
      it 'should be valid' do
        blocked_cpf = BlockedCpf.new(cpf: '11122233300')
  
        blocked_cpf.valid?
  
        expect(blocked_cpf.errors.include? :cpf).to eq true
        expect(blocked_cpf.errors[:cpf].include? 'não é válido').to eq true
      end
  
      it 'should be unique' do
        blocked_cpf_a = BlockedCpf.create!(cpf: '73046259026')
        blocked_cpf_b = BlockedCpf.new(cpf: '73046259026')
  
        blocked_cpf_b.valid?
  
        expect(blocked_cpf_b.errors.include? :cpf).to eq true
        expect(blocked_cpf_b.errors[:cpf].include? 'já está em uso').to eq true
      end
    end
  end
end
