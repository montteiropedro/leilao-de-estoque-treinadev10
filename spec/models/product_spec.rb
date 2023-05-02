require 'rails_helper'

RSpec.describe Product, type: :model do
  describe '#valid?' do
    context 'presence validation' do
      it 'should return false when code is empty' do
        product = Product.new(
          name: 'TV 32 Polegadas', weight: 1_000,
          width: 100, height: 50, depth: 10
        )
        
        allow(SecureRandom).to receive(:alphanumeric).and_return('')
        result = product.valid?
        
        expect(result).to eq false
      end
      
      it 'should return false when name is empty' do
        product = Product.new(
          name: '', weight: 1_000,
          width: 100, height: 50, depth: 10
        )

        result = product.valid?

        expect(result).to eq false
      end
    end

    context 'uniqueness validation' do
      it 'should return false when code is not unique' do
        first_product = Product.new(
          name: 'TV 32 Polegadas', weight: 1_000,
          width: 100, height: 50, depth: 10
        )

        second_product = Product.new(
          name: 'TV 32 Polegadas', weight: 1_000,
          width: 100, height: 50, depth: 10
        )
        
        allow(SecureRandom).to receive(:alphanumeric).and_return('ABCDEFGHIJ')
        first_product.save!

        result = second_product.valid?

        expect(result).to eq false
      end
    end

    context 'length validation' do
      it 'should return false when code length is not 10' do
        product = Product.new(
          name: 'TV 32 Polegadas', weight: 1_000,
          width: 100, height: 50, depth: 10
        )
        
        allow(SecureRandom).to receive(:alphanumeric).and_return('ABCDE')
        result = product.valid?
        
        expect(result).to eq false
      end
    end

    context 'numericality validation' do
      it 'should return false when weight is not an integer greater than 0' do
        product = Product.new(
          name: 'TV 32 Polegadas', weight: -1_000,
          width: 100, height: 50, depth: 10
        )
        
        result = product.valid?
        
        expect(result).to eq false
      end

      it 'should return false when width is not an integer greater than 0' do
        product = Product.new(
          name: 'TV 32 Polegadas', weight: 1_000,
          width: -100, height: 50, depth: 10
        )
        
        result = product.valid?
        
        expect(result).to eq false
      end

      it 'should return false when height is not an integer greater than 0' do
        product = Product.new(
          name: 'TV 32 Polegadas', weight: 1_000,
          width: 100, height: -50, depth: 10
        )
        
        result = product.valid?
        
        expect(result).to eq false
      end

      it 'should return false when depth is not an integer greater than 0' do
        product = Product.new(
          name: 'TV 32 Polegadas', weight: 1_000,
          width: 100, height: 50, depth: -10
        )
        
        result = product.valid?
        
        expect(result).to eq false
      end
    end
  end

  describe '#set_alphanumeric_code' do
    context 'return a alphanumeric random code' do
      it 'should be made automatically' do
        product = Product.new(
          name: 'TV 32 Polegadas', weight: 1_000,
          width: 100, height: 50, depth: 10
        )

        product.valid?
        code = product.code

        expect(code).to be_truthy
      end

      it 'should have length equal to 10' do
        product = Product.new(
          name: 'TV 32 Polegadas', weight: 1_000,
          width: 100, height: 50, depth: 10
        )

        product.valid?
        code_length = product.code.length

        expect(code_length).to eq 10
      end

      it 'should be unique' do
        first_product = Product.create!(
          name: 'TV 32 Polegadas', weight: 1_000,
          width: 100, height: 50, depth: 10
        )

        second_product = Product.new(
          name: 'TV 32 Polegadas', weight: 1_000,
          width: 100, height: 50, depth: 10
        )

        second_product.save!

        expect(second_product.code).not_to eq first_product.code
      end
    end
  end
end
