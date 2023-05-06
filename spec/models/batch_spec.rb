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

    context 'min_bid_in_centavos' do
      it 'should not be empty' do
        batch = Batch.new(min_bid_in_centavos: '')

        batch.valid?

        expect(batch.errors.include? :min_bid_in_centavos).to eq true
        expect(batch.errors[:min_bid_in_centavos].include? 'não pode ficar em branco').to eq true
      end

      it 'should be a positive integer' do
        batch = Batch.new(min_bid_in_centavos: -1)

        batch.valid?

        expect(batch.errors.include? :min_bid_in_centavos).to eq true
        expect(batch.errors[:min_bid_in_centavos].include? 'deve ser um valor inteiro e positivo').to eq true
      end
    end

    context 'min_diff_between_bids_in_centavos' do
      it 'should not be empty' do
        batch = Batch.new(min_diff_between_bids_in_centavos: '')

        batch.valid?

        expect(batch.errors.include? :min_diff_between_bids_in_centavos).to eq true
        expect(batch.errors[:min_diff_between_bids_in_centavos].include? 'não pode ficar em branco').to eq true
      end

      it 'should be a positive integer' do
        batch = Batch.new(min_diff_between_bids_in_centavos: -1)

        batch.valid?

        expect(batch.errors.include? :min_diff_between_bids_in_centavos).to eq true
        expect(batch.errors[:min_diff_between_bids_in_centavos].include? 'deve ser um valor inteiro e positivo').to eq true
      end
    end

    context 'creator' do
      it 'should not be empty' do
        batch = Batch.new

        result = batch.valid?

        expect(batch.errors.include? :creator).to eq true
      end
    end

    context 'approver' do
      it 'should not be the batch creator' do
        admin_user = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )
        batch = Batch.new(creator: admin_user, approver: admin_user)

        batch.valid?

        expect(batch.errors.include? :approver).to eq true
        expect(batch.errors[:approver].include? 'não pode aprovar um lote criado por si mesmo').to eq true
      end
    end
  end
end
