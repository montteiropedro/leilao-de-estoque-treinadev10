require 'rails_helper'

RSpec.describe Lot, type: :model do
  describe '#valid?' do
    context 'code' do
      it 'não deve ser uma string vazia' do
        lot = Lot.new(code: '')

        lot.valid?

        expect(lot.errors.include?(:code)).to eq true
        expect(lot.errors[:code].include?('não pode ficar em branco')).to eq true
      end

      it 'deve possuir 3 letras seguidas de 6 números' do
        lot = Lot.new(code: 'A123B456C')

        lot.valid?

        expect(lot.errors.include?(:code)).to eq true
        expect(lot.errors[:code].include?('deve iniciar com 3 letras maiúsculas e terminar com 6 números')).to eq true
      end

      it 'deve ser único' do
        first_lot = Lot.new(code: Lot.generate_code_suggestion)
        second_lot = Lot.new(code: Lot.generate_code_suggestion)

        expect(second_lot.code).not_to eq first_lot.code
      end
    end

    context 'creator' do
      it 'não deve ser nulo' do
        lot = Lot.new(creator: nil)

        lot.valid?

        expect(lot.errors.include?(:creator)).to eq true
        expect(lot.errors[:creator].include?('é obrigatório(a)')).to eq true
      end
    end

    context 'start_date' do
      it 'não deve ser uma string vazia' do
        lot = Lot.new(start_date: '')

        lot.valid?

        expect(lot.errors.include?(:start_date)).to eq true
        expect(lot.errors[:start_date].include?('não pode ficar em branco')).to eq true
      end

      it 'não deve estar no passado' do
        lot = Lot.new(start_date: 1.day.ago)

        lot.valid?

        expect(lot.errors.include?(:start_date)).to eq true
        expect(lot.errors[:start_date].include?('não pode estar no passado')).to eq true
      end
    end

    context 'end_date' do
      it 'não deve ser uma string vazia' do
        lot = Lot.new(end_date: '')

        lot.valid?

        expect(lot.errors.include?(:end_date)).to eq true
        expect(lot.errors[:end_date].include?('não pode ficar em branco')).to eq true
      end

      it 'deve ser depois da data de início (start_date)' do
        lot = Lot.new(start_date: 1.day.from_now, end_date: Date.current)

        lot.valid?

        expect(lot.errors.include?(:end_date)).to eq true
        expect(lot.errors[:end_date].include?('deve ser depois da data de início')).to eq true
      end
    end

    context 'min_bid_in_centavos' do
      it 'não deve ser uma string vazia' do
        lot = Lot.new(min_bid_in_centavos: '')

        lot.valid?

        expect(lot.errors.include?(:min_bid_in_centavos)).to eq true
        expect(lot.errors[:min_bid_in_centavos].include?('não pode ficar em branco')).to eq true
      end

      it 'deve ser um inteiro positivo' do
        lot = Lot.new(min_bid_in_centavos: -1)

        lot.valid?

        expect(lot.errors.include?(:min_bid_in_centavos)).to eq true
        expect(lot.errors[:min_bid_in_centavos].include?('deve ser um valor inteiro e positivo')).to eq true
      end
    end

    context 'min_diff_between_bids_in_centavos' do
      it 'não deve ser uma string vazia' do
        lot = Lot.new(min_diff_between_bids_in_centavos: '')

        lot.valid?

        expect(lot.errors.include?(:min_diff_between_bids_in_centavos)).to eq true
        expect(lot.errors[:min_diff_between_bids_in_centavos].include?('não pode ficar em branco')).to eq true
      end

      it 'deve ser um inteiro positivo' do
        lot = Lot.new(min_diff_between_bids_in_centavos: -1)

        lot.valid?

        expect(lot.errors.include?(:min_diff_between_bids_in_centavos)).to eq true
        expect(lot.errors[:min_diff_between_bids_in_centavos].include?('deve ser um valor inteiro e positivo')).to eq true
      end
    end

    context 'approver' do
      it 'não deve ser um usuário padrão' do
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

        expect(lot.errors.include?(:approver)).to eq true
        expect(lot.errors[:approver].include?('apenas administradores podem aprovar um lote')).to eq true
      end

      it 'não deve ser o administrador que criou o lote' do
        admin_user = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )
        lot = Lot.new(creator: admin_user, approver: admin_user)

        lot.valid?

        expect(lot.errors.include?(:approver)).to eq true
        expect(lot.errors[:approver].include?('não pode aprovar um lote criado por si mesmo')).to eq true
      end
    end
  end

  describe '#waiting-start?' do
    it 'deve retornar true quando a data de início do leilão do lote é futura' do
      lot = Lot.new(start_date: 1.day.from_now)

      expect(lot.waiting_start?).to eq true
    end

    it 'deve retornar false quando a data de início do leilão não é futura' do
      lot = Lot.new(start_date: Date.current)

      expect(lot.waiting_start?).to eq false
    end
  end

  describe '#in-progress?' do
    it 'deve retornar true quando hoje está entre a data de início (incluso) e fim (incluso) do leilão do lote' do
      lot = Lot.new(start_date: Date.current, end_date: 1.week.from_now)

      expect(lot.in_progress?).to eq true
    end

    it 'deve retornar falso quando hoje não está entre a data de início (incluso) e fim (incluso) do leilão do lote' do
      waiting_start_lot = Lot.new(start_date: 1.day.from_now, end_date: 2.weeks.from_now)
      expired_lot = Lot.new(start_date: 2.weeks.ago, end_date: 1.day.ago)

      expect(waiting_start_lot.in_progress?).to eq false
      expect(expired_lot.in_progress?).to eq false
    end
  end

  describe '#expired?' do
    it 'deve retornar true quando a data de fim do leilão do lote está no passado' do
      lot = Lot.new(end_date: 1.day.ago)

      expect(lot.expired?).to eq true
    end

    it 'deve retornar false quando a data de fim do leilão do lote é hoje ou futura' do
      lot_a = Lot.new(end_date: Date.current)
      lot_b = Lot.new(end_date: 1.week.from_now)

      expect(lot_a.expired?).to eq false
      expect(lot_b.expired?).to eq false
    end
  end
end
