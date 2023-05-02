require 'rails_helper'

RSpec.describe Bid, type: :model do
  describe '#valid?' do
    context 'presence validation' do
      it 'should return false when value is empty' do
        user = User.create!(
          name: 'Peter Parker', cpf: '73046259026',
          email: 'peter@email.com', password: 'mypass45678'
        )

        admin = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )

        batch = Batch.new(
          code: 'COD123456', start_date: '2023-10-05', end_date: '2023-12-20',
          minimum_bid: 10_000, minimum_difference_between_bids: 5_000,
          creator: admin
        )
        
        bid = Bid.new(value: '', user: user, batch: batch)

        result = bid.valid?

        expect(result).to eq false
      end

      it 'should return false when user is empty' do
        user = User.create!(
          name: 'Peter Parker', cpf: '73046259026',
          email: 'peter@email.com', password: 'mypass45678'
        )

        admin = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )

        batch = Batch.new(
          code: 'COD123456', start_date: '2023-10-05', end_date: '2023-12-20',
          minimum_bid: 10_000, minimum_difference_between_bids: 5_000,
          creator: admin
        )
        
        bid = Bid.new(value: 1_000, user: nil, batch: batch)

        result = bid.valid?

        expect(result).to eq false
      end

      it 'should return false when batch is empty' do
        user = User.create!(
          name: 'Peter Parker', cpf: '73046259026',
          email: 'peter@email.com', password: 'mypass45678'
        )
        
        admin = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )

        batch = Batch.new(
          code: 'COD123456', start_date: '2023-10-05', end_date: '2023-12-20',
          minimum_bid: 10_000, minimum_difference_between_bids: 5_000,
          creator: admin
        )
        
        bid = Bid.new(value: 1_000, user: user, batch: nil)

        result = bid.valid?

        expect(result).to eq false
      end
    end

    context 'numericality validation' do
      it 'should return false when value is less than or equal to 0' do
        user = User.create!(
          name: 'Peter Parker', cpf: '73046259026',
          email: 'peter@email.com', password: 'mypass45678'
        )
        
        admin = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )

        batch = Batch.new(
          code: 'COD123456', start_date: '2023-10-05', end_date: '2023-12-20',
          minimum_bid: 10_000, minimum_difference_between_bids: 5_000,
          creator: admin
        )
        
        bid = Bid.new(value: -1_000, user: user, batch: batch)

        result = bid.valid?

        expect(result).to eq false
      end
    end
  end
end
