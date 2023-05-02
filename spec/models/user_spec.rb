require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#valid?' do
    context 'presence validation' do
      it 'should return false when name is empty' do
        user = User.new(
          name: '', cpf: '73046259026',
          email: 'peter@email.com', password: 'mypass45678'
        )

        result = user.valid?

        expect(result).to eq false
      end

      it 'should return false when cpf is empty' do
        user = User.new(
          name: 'Peter Parker', cpf: '',
          email: 'peter@email.com', password: 'mypass45678'
        )

        result = user.valid?

        expect(result).to eq false
      end

      it 'should return false when email is empty' do
        user = User.new(
          name: 'Peter Parker', cpf: '73046259026',
          email: '', password: 'mypass45678'
        )

        result = user.valid?

        expect(result).to eq false
      end

      it 'should return false when password is empty' do
        user = User.new(
          name: 'Peter Parker', cpf: '73046259026',
          email: 'peter@email.com', password: ''
        )

        result = user.valid?

        expect(result).to eq false
      end
    end

    context 'uniqueness validation' do
      it 'should return false when cpf in not unique' do
        first_user = User.create!(
          name: 'Peter Parker', cpf: '73046259026',
          email: 'peter@email.com', password: 'mypass45678'
        )

        second_user = User.new(
          name: 'Fake Peter Parker', cpf: '73046259026',
          email: 'fake_peter@email.com', password: 'my45678pass'
        )

        result = second_user.valid?

        expect(result).to eq false
      end
    end

    context 'length validation' do
      it 'should return false when cpf length is not 11' do
        user = User.new(
          name: 'Peter Parker', cpf: '73046',
          email: 'peter@email.com', password: 'mypass45678'
        )

        result = user.valid?

        expect(result).to eq false
      end
    end
  end

  describe '#set_admin' do
    context 'before validation' do
      it 'should set admin to true when email prefix equals to "@leilaodogalpao.com.br"' do
        user = User.new(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )

        user.valid?

        expect(user.admin).to eq true
      end

      it 'should set admin to false when email prefix does not equal to "@leilaodogalpao.com.br"' do
        user = User.new(
          name: 'Peter Parker', cpf: '73046259026',
          email: 'peter@email.com', password: 'mypass45678'
        )

        user.valid?

        expect(user.admin).to eq false
      end

      it 'should change admin from true to false when email prefix changes and is not equal to "@leilaodogalpao.com.br"' do
        user = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )

        user.update!(email: 'john@email.com')

        expect(user.admin).to eq false
      end
    end
  end

  describe '#can_make_a_bid?' do
    it 'should return true when user is not a admin' do
      user = User.create!(
        name: 'Peter Parker', cpf: '73046259026',
        email: 'peter@email.com', password: 'mypass45678'
      )

      result = user.can_make_a_bid?

      expect(result).to eq true
    end

    it 'should return false when user is a admin' do
      admin = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )

      result = admin.can_make_a_bid?

      expect(result).to eq false
    end
  end
end
