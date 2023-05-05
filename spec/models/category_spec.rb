require 'rails_helper'

RSpec.describe Category, type: :model do
  describe '#valid?' do
    context 'name' do
      it 'should not be empty' do
        category = Category.new(name: '')

        category.valid?

        expect(category.errors.include? :name).to eq true
        expect(category.errors[:name].include? 'não pode ficar em branco').to eq true
      end

      it 'should be unique' do
        first_category = Category.create!(name: 'Electronic')
        second_category = Category.new(name: 'Electronic')

        second_category.valid?

        expect(second_category.errors.include? :name).to eq true
        expect(second_category.errors[:name].include? 'já está em uso').to eq true
      end
    end
  end
end
