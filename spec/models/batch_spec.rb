require 'rails_helper'


RSpec.describe Batch, type: :model do
  describe '#valid?' do
    context 'code' do
      it 'should not be empty' do
        batch = Batch.new(code: '')
        
        batch.valid?

        expect(batch.errors.include? :code).to eq true
        expect(batch.errors[:code].include? 'não pode ficar em branco').to eq true
      end

      it 'should have 3 letters followed by 6 numbers' do
        batch = Batch.new(code: 'A123B456C')
        
        batch.valid?

        expect(batch.errors.include? :code).to eq true
        expect(batch.errors[:code].include? 'deve iniciar com 3 letras maiúsculas e terminar com 6 números').to eq true
      end

      it 'should be unique' do
        first_batch = Batch.new(code: Batch.generate_code_suggestion)
        second_batch = Batch.new(code: Batch.generate_code_suggestion)
        
        expect(second_batch.code).not_to eq first_batch.code
      end
    end

    context 'start_date' do
      it 'should not be empty' do
        batch = Batch.new(start_date: '')

        batch.valid?

        expect(batch.errors.include? :start_date).to eq true
        expect(batch.errors[:start_date].include? 'não pode ficar em branco').to eq true
      end

      it 'should not be in the past' do
        batch = Batch.new(start_date: Date.today - 1.day)

        batch.valid?

        expect(batch.errors.include? :start_date).to eq true
        expect(batch.errors[:start_date].include? 'não pode estar no passado').to eq true
      end
    end

    context 'end_date' do
      it 'should not be empty' do
        batch = Batch.new(end_date: '')

        batch.valid?

        expect(batch.errors.include? :end_date).to eq true
        expect(batch.errors[:end_date].include? 'não pode ficar em branco').to eq true
      end

      it 'should be after start_date' do
        batch = Batch.new(start_date: Date.today + 1.day, end_date: Date.today)

        batch.valid?

        expect(batch.errors.include? :end_date).to eq true
        expect(batch.errors[:end_date].include? 'deve ser depois da data de início').to eq true
      end
    end

    context 'minimum_bid' do
      it 'should not be empty' do
        batch = Batch.new(minimum_bid: '')

        batch.valid?

        expect(batch.errors.include? :minimum_bid).to eq true
        expect(batch.errors[:minimum_bid].include? 'não pode ficar em branco').to eq true
      end

      it 'should be a positive integer' do
        batch = Batch.new(minimum_bid: -1_000)

        batch.valid?

        expect(batch.errors.include? :minimum_bid).to eq true
        expect(batch.errors[:minimum_bid].include? 'deve ser um valor inteiro e positivo').to eq true
      end
    end

    context 'minimum_difference_between_bids' do
      it 'should not be empty' do
        batch = Batch.new(minimum_difference_between_bids: '')

        batch.valid?

        expect(batch.errors.include? :minimum_difference_between_bids).to eq true
        expect(batch.errors[:minimum_difference_between_bids].include? 'não pode ficar em branco').to eq true
      end

      it 'should be a positive integer' do
        batch = Batch.new(minimum_difference_between_bids: -1_000)

        batch.valid?

        expect(batch.errors.include? :minimum_difference_between_bids).to eq true
        expect(batch.errors[:minimum_difference_between_bids].include? 'deve ser um valor inteiro e positivo').to eq true
      end
    end

    context 'creator' do
      it 'should not be empty' do
        batch = Batch.new

        result = batch.valid?

        expect(batch.errors.include? :creator).to eq true
      end
    end
  end
end
