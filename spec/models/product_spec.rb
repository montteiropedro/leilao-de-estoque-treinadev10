require 'rails_helper'

RSpec.describe Product, type: :model do
  describe '#valid?' do
    context 'code' do
      it 'should not be empty' do
        allow(SecureRandom).to receive(:alphanumeric).and_return('')
        product = Product.new
        
        product.valid?
        
        expect(product.errors.include? :code).to eq true
        expect(product.errors[:code].include? 'não pode ficar em branco').to eq true
      end

      it 'should be unique' do
        allow(SecureRandom).to receive(:alphanumeric).and_return('ABCDEFGHIJ')
        first_product = Product.create!(
          name: 'TV 32 Polegadas', weight: 1_000,
          width: 100, height: 50, depth: 10
        )
        second_product = Product.new
        
        second_product.valid?

        expect(second_product.errors.include? :code).to eq true
        expect(second_product.errors[:code].include? 'já está em uso').to eq true
      end

      it 'should return false when code length is not 10' do
        allow(SecureRandom).to receive(:alphanumeric).and_return('ABC12')
        product = Product.new
        
        product.valid?
        
        expect(product.errors.include? :code).to eq true
        expect(product.errors[:code].include? 'não possui o tamanho esperado (10 caracteres)').to eq true
      end
    end

    context 'name' do
      it 'should not be empty' do
        product = Product.new(name: '')

        product.valid?

        expect(product.errors.include? :name).to eq true
        expect(product.errors[:name].include? 'não pode ficar em branco').to eq true
      end
    end

    context 'weight' do
      it 'should be a integer greater than 0' do
        product = Product.new(weight: -1)
        
        product.valid?
        
        expect(product.errors.include? :weight).to eq true
        expect(product.errors[:weight].include? 'deve ser maior que 0').to eq true
      end
    end

    context 'width' do
      it 'should be a integer greater than 0' do
        product = Product.new(width: -1)
        
        product.valid?
        
        expect(product.errors.include? :width).to eq true
        expect(product.errors[:width].include? 'deve ser maior que 0').to eq true
      end
    end

    context 'height' do
      it 'should be a integer greater than 0' do
        product = Product.new(height: -1)
        
        product.valid?
        
        expect(product.errors.include? :height).to eq true
        expect(product.errors[:height].include? 'deve ser maior que 0').to eq true
      end
    end

    context 'depth' do
      it 'should be a integer greater than 0' do
        product = Product.new(depth: -1)
        
        product.valid?
        
        expect(product.errors.include? :depth).to eq true
        expect(product.errors[:depth].include? 'deve ser maior que 0').to eq true
      end
    end
  end

  describe '#set_alphanumeric_code' do
    context 'return a alphanumeric random code' do
      it 'should be made automatically' do
        product = Product.new

        product.valid?

        expect(product.code).to be_truthy
      end

      it 'should have size equal to 10' do
        product = Product.new

        product.valid?

        expect(product.code.size).to eq 10
      end

      it 'should be unique' do
        first_product = Product.new
        second_product = Product.new

        first_product.valid?
        second_product.valid?

        expect(second_product.code).not_to eq first_product.code
      end
    end
  end
end
