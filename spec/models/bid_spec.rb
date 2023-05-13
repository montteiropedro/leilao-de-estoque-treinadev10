require 'rails_helper'

RSpec.describe Bid, type: :model do
  describe '#valid?' do
    context 'value_in_centavos' do
      it 'should not be empty' do
        bid = Bid.new(value_in_centavos: '')

        bid.valid?

        expect(bid.errors.include? :value_in_centavos).to eq true
        expect(bid.errors[:value_in_centavos].include? 'não pode ficar em branco').to eq true
      end

      it 'should not be less than or equal to 0' do
        bid = Bid.new(value_in_centavos: -1)

        bid.valid?

        expect(bid.errors.include? :value_in_centavos).to eq true
        expect(bid.errors[:value_in_centavos].include? 'deve ser maior que 0').to eq true
      end
    end

    context 'user' do
      it 'should not be a visitant (be empty)' do
        bid = Bid.new(user: nil)

        bid.valid?

        expect(bid.errors.include? :user).to eq true
        expect(bid.errors[:user].include? 'é obrigatório(a)').to eq true
      end

      it 'should not be a admin' do
        admin_user = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )
        bid = Bid.new(user: admin_user)

        bid.valid?

        expect(bid.errors.include? :user).to eq true
        expect(bid.errors[:user].include? 'administradores não podem fazer lances').to eq true
      end

      it 'should be a non admin user' do
        user = User.create!(
          name: 'Peter Parker', cpf: '73046259026',
          email: 'peter@email.com', password: 'password123'
        )
        bid = Bid.new(user: user)

        bid.valid?

        expect(bid.errors.include? :user).to eq false
      end
    end

    context 'lot' do
      it 'should not be empty' do
        bid = Bid.new(lot: nil)

        bid.valid?

        expect(bid.errors.include? :lot).to eq true
        expect(bid.errors[:lot].include? 'é obrigatório(a)').to eq true
      end
    end
  end
end
