require 'rails_helper'

describe 'Usuário loga na aplicação' do
  it 'através da barra de navegação' do
    visit root_path
    within 'nav' do
      click_on 'Entrar'
    end

    expect(current_path).to eq new_user_session_path
    within 'form' do
      expect(page).to have_field 'E-mail'
      expect(page).to have_field 'Senha'
    end
  end

  it 'e consegue acessar sua conta se informar email e senha válidos' do
    User.create!(
      name: 'Peter Parker', cpf: '73046259026',
      email: 'peter@email.com', password: 'password123'
    )

    visit root_path
    click_on 'Entrar'
    within 'form' do
      fill_in 'E-mail', with: 'peter@email.com'
      fill_in 'Senha', with: 'password123'
      click_on 'Entrar'
    end

    expect(page).to have_content 'Login efetuado com sucesso.'
    within 'nav' do
      expect(page).to have_content 'Peter Parker'
      expect(page).to have_link 'Sair'
      expect(page).not_to have_link 'Entrar'
    end
  end

  it 'e não consegue acessar sua conta se informar email e senha inválidos' do
    User.create!(
      name: 'Peter Parker', cpf: '73046259026',
      email: 'peter@email.com', password: 'password123'
    )

    visit root_path
    click_on 'Entrar'
    within 'form' do
      fill_in 'E-mail', with: 'wrong_peter@email.com'
      fill_in 'Senha', with: 'wrongpass123'
      click_on 'Entrar'
    end

    expect(page).to have_content 'E-mail ou senha inválidos.'
    within 'nav' do
      expect(page).to have_link 'Entrar'
      expect(page).not_to have_content 'Peter Parker'
      expect(page).not_to have_link 'Sair'
    end
  end
end
