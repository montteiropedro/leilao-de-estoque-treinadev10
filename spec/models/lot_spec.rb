require 'rails_helper'


RSpec.describe Lot, type: :model do
  describe '#valid?' do
    context 'code' do
      it 'should not be empty' do
        lot = Lot.new(code: '')
        
        lot.valid?

        expect(lot.errors.include? :code).to eq true
        expect(lot.errors[:code].include? 'não pode ficar em branco').to eq true
      end

      it 'should have 3 letters followed by 6 numbers' do
        lot = Lot.new(code: 'A123B456C')
        
        lot.valid?

        expect(lot.errors.include? :code).to eq true
        expect(lot.errors[:code].include? 'deve iniciar com 3 letras maiúsculas e terminar com 6 números').to eq true
      end

      it 'should be unique' do
        first_lot = Lot.new(code: Lot.generate_code_suggestion)
        second_lot = Lot.new(code: Lot.generate_code_suggestion)
        
        expect(second_lot.code).not_to eq first_lot.code
      end
    end

    context 'start_date' do
      it 'should not be empty' do
        lot = Lot.new(start_date: '')

        lot.valid?

        expect(lot.errors.include? :start_date).to eq true
        expect(lot.errors[:start_date].include? 'não pode ficar em branco').to eq true
      end

      it 'should not be in the past' do
        lot = Lot.new(start_date: Date.today - 1.day)

        lot.valid?

        expect(lot.errors.include? :start_date).to eq true
        expect(lot.errors[:start_date].include? 'não pode estar no passado').to eq true
      end
    end

    context 'end_date' do
      it 'should not be empty' do
        lot = Lot.new(end_date: '')

        lot.valid?

        expect(lot.errors.include? :end_date).to eq true
        expect(lot.errors[:end_date].include? 'não pode ficar em branco').to eq true
      end

      it 'should be after start_date' do
        lot = Lot.new(start_date: Date.today + 1.day, end_date: Date.today)

        lot.valid?

        expect(lot.errors.include? :end_date).to eq true
        expect(lot.errors[:end_date].include? 'deve ser depois da data de início').to eq true
      end
    end

    context 'min_bid_in_centavos' do
      it 'should not be empty' do
        lot = Lot.new(min_bid_in_centavos: '')

        lot.valid?

        expect(lot.errors.include? :min_bid_in_centavos).to eq true
        expect(lot.errors[:min_bid_in_centavos].include? 'não pode ficar em branco').to eq true
      end

      it 'should be a positive integer' do
        lot = Lot.new(min_bid_in_centavos: -1)

        lot.valid?

        expect(lot.errors.include? :min_bid_in_centavos).to eq true
        expect(lot.errors[:min_bid_in_centavos].include? 'deve ser um valor inteiro e positivo').to eq true
      end
    end

    context 'min_diff_between_bids_in_centavos' do
      it 'should not be empty' do
        lot = Lot.new(min_diff_between_bids_in_centavos: '')

        lot.valid?

        expect(lot.errors.include? :min_diff_between_bids_in_centavos).to eq true
        expect(lot.errors[:min_diff_between_bids_in_centavos].include? 'não pode ficar em branco').to eq true
      end

      it 'should be a positive integer' do
        lot = Lot.new(min_diff_between_bids_in_centavos: -1)

        lot.valid?

        expect(lot.errors.include? :min_diff_between_bids_in_centavos).to eq true
        expect(lot.errors[:min_diff_between_bids_in_centavos].include? 'deve ser um valor inteiro e positivo').to eq true
      end
    end

    context 'creator' do
      it 'should not be empty' do
        lot = Lot.new

        result = lot.valid?

        expect(lot.errors.include? :creator).to eq true
      end
    end

    context 'approver' do
      it 'should not be a non admin user' do
        user = User.create!(
          name: 'Peter Parker', cpf: '73046259026',
          email: 'peter@email.com', password: 'password123'
        )
        admin_user = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )
        lot = Lot.new(creator: admin_user, approver: user)

        lot.valid?

        expect(lot.errors.include? :approver).to eq true
        expect(lot.errors[:approver].include? 'apenas administradores podem aprovar um lote').to eq true
      end

      it 'should not be the lot creator' do
        admin_user = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )
        lot = Lot.new(creator: admin_user, approver: admin_user)

        lot.valid?

        expect(lot.errors.include? :approver).to eq true
        expect(lot.errors[:approver].include? 'não pode aprovar um lote criado por si mesmo').to eq true
      end
    end
  end

  describe '#waiting-start?' do
    it 'should return true when today is before start_date' do
      lot = Lot.new(start_date: Date.today + 1.day)

      expect(lot.waiting_start?).to eq true
    end

    it 'should return false when today is not before start_date' do
      lot = Lot.new(start_date: Date.today)

      expect(lot.waiting_start?).to eq false
    end
  end

  describe '#in-progress?' do
    it 'should return true when today is between start_date (included) and end_date (included)' do
      lot = Lot.new(start_date: Date.today, end_date: Date.today + 1.week)

      expect(lot.in_progress?).to eq true
    end

    it 'should return false when today is not between start_date (included) and end_date (included)' do
      waiting_start_lot = Lot.new(start_date: Date.today + 1.day, end_date: Date.today + 2.week)
      expired_lot = Lot.new(start_date: Date.today - 2.weeks, end_date: Date.today - 1.day)

      expect(waiting_start_lot.in_progress?).to eq false
      expect(expired_lot.in_progress?).to eq false
    end
  end

  describe '#expired?' do
    it 'should return true when today is after end_date' do
      lot = Lot.new(end_date: Date.today - 1.day)

      expect(lot.expired?).to eq true
    end

    it 'should return false when today is not after end_date' do
      lot = Lot.new(end_date: Date.today)

      expect(lot.expired?).to eq false
    end
  end
end
