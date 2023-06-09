require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#valid?' do
    describe 'is_admin' do
      it 'deve ser true quando o e-mail possuir endereço igual a "@leilaodogalpao.com.br"' do
        user = User.new(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )

        user.valid?

        expect(user.is_admin).to eq true
      end

      it 'deve ser false quando o e-mail possuir endereço diferente de "@leilaodogalpao.com.br"' do
        user = User.new(
          name: 'Peter Parker', cpf: '73046259026',
          email: 'peter@email.com', password: 'mypass45678'
        )

        user.valid?

        expect(user.is_admin).to eq false
      end

      context 'quando o endereço de e-mail muda' do
        it 'de "@leilaodogalpao.com.br" para qualquer outro endereço, deve atualizar de true para false' do
          user = User.create!(
            name: 'John Doe', cpf: '41760209031',
            email: 'john@leilaodogalpao.com.br', password: 'password123'
          )

          user.update!(email: 'john@email.com')

          expect(user.is_admin).to eq false
        end

        it 'de qualquer outro endereço para "@leilaodogalpao.com.br", deve atualizar de false para true' do
          user = User.create!(
            name: 'John Doe', cpf: '41760209031',
            email: 'john@email.com', password: 'password123'
          )

          user.update!(email: 'john@leilaodogalpao.com.br')

          expect(user.is_admin).to eq true
        end
      end
    end

    describe 'name' do
      it 'não deve ser uma string vazia' do
        user = User.new(name: '')

        user.valid?

        expect(user.errors.include?(:name)).to eq true
        expect(user.errors[:name].include?('não pode ficar em branco')).to eq true
      end
    end

    describe 'cpf' do
      it 'não deve ser uma string vazia' do
        user = User.new(cpf: '')

        user.valid?

        expect(user.errors.include?(:cpf)).to eq true
        expect(user.errors[:cpf].include?('não pode ficar em branco')).to eq true
      end

      it 'deve possuir tamanho igual a 11' do
        user = User.new(cpf: '417602')

        user.valid?

        expect(user.errors.include?(:cpf)).to eq true
        expect(user.errors[:cpf].include?('não possui o tamanho esperado (11 caracteres)')).to eq true
      end

      it 'deve ser um CPF válido' do
        user = User.new(cpf: '11122233300')

        user.valid?

        expect(user.errors.include?(:cpf)).to eq true
        expect(user.errors[:cpf].include?('não é válido')).to eq true
      end

      it 'deve ser único' do
        User.create!(
          name: 'Peter Parker', cpf: '73046259026',
          email: 'peter@email.com', password: 'mypass45678'
        )
        second_user = User.new(cpf: '73046259026')

        second_user.valid?

        expect(second_user.errors.include?(:cpf)).to eq true
        expect(second_user.errors[:cpf].include?('já está em uso')).to eq true
      end
    end

    describe 'email' do
      it 'não deve ser uma string vazia' do
        user = User.new(email: '')

        user.valid?

        expect(user.errors.include?(:cpf)).to eq true
        expect(user.errors[:cpf].include?('não pode ficar em branco')).to eq true
      end

      it 'deve ser válido' do
        user = User.new(email: 'useremail.com')

        user.valid?

        expect(user.errors.include?(:email)).to eq true
        expect(user.errors[:email].include?('não é válido')).to eq true
      end
    end

    describe 'password' do
      it 'não deve ser uma string vazia' do
        user = User.new(password: '')

        user.valid?

        expect(user.errors.include?(:password)).to eq true
        expect(user.errors[:password].include?('não pode ficar em branco')).to eq true
      end
    end
  end

  describe '#can_make_bid?' do
    it 'should return true when user is not a admin' do
      user = User.create!(
        name: 'Peter Parker', cpf: '73046259026',
        email: 'peter@email.com', password: 'mypass45678'
      )

      result = user.can_make_bid?

      expect(result).to eq true
    end

    it 'should return false when user is a admin' do
      admin = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )

      result = admin.can_make_bid?

      expect(result).to eq false
    end
  end
end
