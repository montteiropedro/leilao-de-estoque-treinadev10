require 'rails_helper'

RSpec.describe Category, type: :model do
  describe '#valid?' do
    context 'presence validation' do
      it 'should return false when name is empty' do
        category = Category.new(name: '')

        result = category.valid?

        expect(result).to eq false
      end
    end

    context 'uniqueness validation' do
      it 'should return false when name is not unique' do
        first_category = Category.create!(name: 'Electronic')
        second_category = Category.new(name: 'Electronic')

        result = second_category.valid?

        expect(result).to eq false
      end
    end
  end
end
