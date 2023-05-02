require 'rails_helper'


RSpec.describe Batch, type: :model do
  describe '#valid?' do
    context 'presence validation' do
      it 'should return false when code is empty' do
        admin = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )

        batch = Batch.new(
          code: '', start_date: '2023-10-05', end_date: '2023-12-20',
          minimum_bid: 10_000, minimum_difference_between_bids: 5_000,
          creator: admin
        )

        result = batch.valid?

        expect(result).to eq false
      end

      it 'should return false when start_date is empty' do
        admin = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )

        batch = Batch.new(
          code: 'COD123456', start_date: '', end_date: '2023-12-20',
          minimum_bid: 10_000, minimum_difference_between_bids: 5_000,
          creator: admin
        )

        result = batch.valid?

        expect(result).to eq false
      end

      it 'should return false when end_date is empty' do
        admin = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )

        batch = Batch.new(
          code: 'COD123456', start_date: '2023-10-05', end_date: '',
          minimum_bid: 10_000, minimum_difference_between_bids: 5_000,
          creator: admin
        )

        result = batch.valid?

        expect(result).to eq false
      end

      it 'should return false when minimum_bid is empty' do
        admin = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )

        batch = Batch.new(
          code: 'COD123456', start_date: '2023-10-05', end_date: '2023-12-20',
          minimum_bid: '', minimum_difference_between_bids: 5_000,
          creator: admin
        )

        result = batch.valid?

        expect(result).to eq false
      end

      it 'should return false when minimum_difference_between_bids is empty' do
        admin = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )

        batch = Batch.new(
          code: 'COD123456', start_date: '2023-10-05', end_date: '2023-12-20',
          minimum_bid: 10_000, minimum_difference_between_bids: '',
          creator: admin
        )

        result = batch.valid?

        expect(result).to eq false
      end

      it 'should return false when creator is empty' do
        admin = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )

        batch = Batch.new(
          code: 'COD123456', start_date: '2023-10-05', end_date: '2023-12-20',
          minimum_bid: 10_000, minimum_difference_between_bids: 5_000,
          creator: nil
        )

        result = batch.valid?

        expect(result).to eq false
      end

      pending 'should return false when creator references a non admin user'
    end

    context 'uniqueness validation' do
      it 'should return false when code is not unique' do
        admin = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )

        first_batch = Batch.create!(
          code: 'COD123456', start_date: '2023-10-05', end_date: '2023-12-20',
          minimum_bid: 10_000, minimum_difference_between_bids: 5_000,
          creator: admin
        )

        second_batch = Batch.new(
          code: 'COD123456', start_date: '2023-10-05', end_date: '2023-12-20',
          minimum_bid: 10_000, minimum_difference_between_bids: 5_000,
          creator: admin
        )

        result = second_batch.valid?

        expect(result).to eq false
      end
    end

    context 'format validation' do
      it 'should return false when code does not match de specified format' do
        admin = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )

        batch = Batch.new(
          code: '123456COD', start_date: '2023-10-05', end_date: '2023-12-20',
          minimum_bid: 10_000, minimum_difference_between_bids: 5_000,
          creator: admin
        )

        result = batch.valid?

        expect(result).to eq false
      end
    end

    context 'comparison validation' do
      it 'should return false when start_date is not before the end_date' do
        admin = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )

        batch = Batch.new(
          code: 'COD123456', start_date: '2023-12-20', end_date: '2023-10-05',
          minimum_bid: 10_000, minimum_difference_between_bids: 5_000,
          creator: admin
        )

        result = batch.valid?

        expect(result).to eq false
      end
    end

    context 'numericality validation' do
      it 'should return false when minimum_bid a integer less than or equal to 0' do
        admin = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )

        batch = Batch.new(
          code: 'COD123456', start_date: '2023-10-05', end_date: '2023-12-20',
          minimum_bid: -10_000, minimum_difference_between_bids: 5_000,
          creator: admin
        )

        result = batch.valid?

        expect(result).to eq false
      end

      it 'should return false when minimum_difference_between_bids is a integer less than or equal to 0' do
        admin = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )

        batch = Batch.new(
          code: 'COD123456', start_date: '2023-10-05', end_date: '2023-12-20',
          minimum_bid: 10_000, minimum_difference_between_bids: -5_000,
          creator: admin
        )

        result = batch.valid?

        expect(result).to eq false
      end
    end
  end
end
