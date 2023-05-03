require 'rails_helper'

describe 'User visits login homepage' do
  it 'from navigation menu' do
    visit root_path
    within('nav') do
      click_on 'Entrar'
    end

    expect(current_path).to eq new_user_session_path

    within('form') do
      expect(page).to have_field 'E-mail'
      expect(page).to have_field 'Senha'
    end
  end

  context 'login' do
    it 'should be successful with a valid email and password' do
      User.create!(
        name: 'Peter Parker', cpf: '73046259026',
        email: 'peter@email.com', password: 'password123'
      )

      visit root_path
      click_on 'Entrar'

      within('form') do
        fill_in 'E-mail', with: 'peter@email.com'
        fill_in 'Senha', with: 'password123'
        click_on 'Entrar'
      end

      expect(page).to have_content 'Login efetuado com sucesso.'

      within('nav') do
        expect(page).not_to have_link 'Entrar'

        expect(page).to have_content 'Peter Parker'
        expect(page).to have_link 'Sair'
      end
    end

    it 'should not be successful with a invalid email and password' do
      User.create!(
        name: 'Peter Parker', cpf: '73046259026',
        email: 'peter@email.com', password: 'password123'
      )

      visit root_path
      click_on 'Entrar'

      within('form') do
        fill_in 'E-mail', with: 'wrong_peter@email.com'
        fill_in 'Senha', with: 'wrongpass123'
        click_on 'Entrar'
      end

      expect(page).to have_content 'E-mail ou senha inválidos.'

      within('nav') do
        expect(page).not_to have_content 'Peter Parker'
        expect(page).not_to have_link 'Sair'

        expect(page).to have_link 'Entrar'
      end
    end
  end

  context 'logout' do
    it 'should be successful' do
      User.create!(
        name: 'Peter Parker', cpf: '73046259026',
        email: 'peter@email.com', password: 'password123'
      )

      visit root_path
      click_on 'Entrar'

      within('form') do
        fill_in 'E-mail', with: 'peter@email.com'
        fill_in 'Senha', with: 'password123'
        click_on 'Entrar'
      end

      click_on 'Sair'

      expect(page).to have_content 'Logout efetuado com sucesso.'

      within('nav') do
        expect(page).not_to have_content 'Peter Parker'
        expect(page).not_to have_button 'Sair'

        expect(page).to have_link 'Entrar'
      end
    end
  end
end
