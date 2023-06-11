require 'rails_helper'

RSpec.describe Product, type: :model do
  describe '#valid?' do
    context 'code' do
      it 'não deve ser uma string vazia' do
        allow(SecureRandom).to receive(:alphanumeric).and_return('')
        product = Product.new

        product.valid?

        expect(product.errors.include?(:code)).to eq true
        expect(product.errors[:code].include?('não pode ficar em branco')).to eq true
      end

      it 'deve possuir 10 caracteres' do
        allow(SecureRandom).to receive(:alphanumeric).and_return('ABC12')
        product = Product.new

        product.valid?

        expect(product.errors.include?(:code)).to eq true
        expect(product.errors[:code].include?('não possui o tamanho esperado (10 caracteres)')).to eq true
      end

      it 'deve ser único' do
        first_product = Product.new
        second_product = Product.new

        first_product.valid?
        second_product.valid?

        expect(second_product.code).not_to eq first_product.code
      end
    end

    context 'name' do
      it 'não deve ser uma string vazia' do
        product = Product.new(name: '')

        product.valid?

        expect(product.errors.include?(:name)).to eq true
        expect(product.errors[:name].include?('não pode ficar em branco')).to eq true
      end
    end

    context 'weight' do
      it 'deve ser um inteiro positivo' do
        product = Product.new(weight: -1)

        product.valid?

        expect(product.errors.include?(:weight)).to eq true
        expect(product.errors[:weight].include?('deve ser maior que 0')).to eq true
      end
    end

    context 'width' do
      it 'deve ser um inteiro positivo' do
        product = Product.new(width: -1)

        product.valid?

        expect(product.errors.include?(:width)).to eq true
        expect(product.errors[:width].include?('deve ser maior que 0')).to eq true
      end
    end

    context 'height' do
      it 'deve ser um inteiro positivo' do
        product = Product.new(height: -1)

        product.valid?

        expect(product.errors.include?(:height)).to eq true
        expect(product.errors[:height].include?('deve ser maior que 0')).to eq true
      end
    end

    context 'depth' do
      it 'should be a integer greater than 0' do
        product = Product.new(depth: -1)

        product.valid?

        expect(product.errors.include?(:depth)).to eq true
        expect(product.errors[:depth].include?('deve ser maior que 0')).to eq true
      end
    end
  end

  describe '.set_alphanumeric_code' do
    it 'não deve sobrescrever o código original do produto durante um update' do
      product = Product.new

      product.valid?
      initial_code = product.code
      product.update!(
        name: 'Quadro', weight: 1_000,
        width: 30, height: 50, depth: 5
      )
      after_update_code = product.code

      expect(initial_code).to eq after_update_code
    end
  end

  describe '.set_status' do
    context 'quando o produto não esta vinculado a um lote' do
      it 'deve definir o status como "available"' do
        product = Product.new

        product.valid?

        expect(product.status).to eq 'available'
      end
    end

    context 'quando o produto esta vinculado a um lote' do
      it 'deve definir o status como "unavailable" se o lote não possuir um comprador' do
        user_admin = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )
        lot = Lot.create!(
          code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.month,
          min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
          creator: user_admin
        )
        product = Product.new(lot: lot)

        product.valid?

        expect(product.status).to eq 'unavailable'
      end

      it 'deve definir o status como "vendido" se o lote possuir um comprador' do
        user = User.create!(
          name: 'Peter Parker', cpf: '73046259026',
          email: 'peter@email.com', password: 'password123'
        )
        user_admin = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )
        Lot.new(
          code: 'COD123456', start_date: Date.today - 1.week, end_date: Date.today - 1.day,
          min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
          creator: user_admin, buyer: user
        ).save!(validate: false)
        product = Product.new(lot: Lot.last)

        product.valid?

        expect(product.status).to eq 'sold'
      end
    end
  end
end
