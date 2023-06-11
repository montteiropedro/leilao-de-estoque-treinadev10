require 'rails_helper'

RSpec.describe Category, type: :model do
  describe '#valid?' do
    context 'name' do
      it 'não deve ser uma string vazia' do
        category = Category.new(name: '')

        category.valid?

        expect(category.errors.include?(:name)).to eq true
        expect(category.errors[:name].include?('não pode ficar em branco')).to eq true
      end

      it 'deve ser único' do
        Category.create!(name: 'Electronics')
        second_category = Category.new(name: 'Electronics')

        second_category.valid?

        expect(second_category.errors.include?(:name)).to eq true
        expect(second_category.errors[:name].include?('já está em uso')).to eq true
      end
    end
  end
end
