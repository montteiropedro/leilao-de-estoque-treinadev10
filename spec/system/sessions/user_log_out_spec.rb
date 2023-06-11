require 'rails_helper'

describe 'Usuário desloga da aplicação' do
  it 'através da barra de navegação' do
    user = User.create!(
      name: 'Peter Parker', cpf: '73046259026',
      email: 'peter@email.com', password: 'password123'
    )

    login_as user
    visit root_path
    within 'nav' do
      click_on 'Sair'
    end

    expect(current_path).to eq root_path
    expect(page).to have_content 'Logout efetuado com sucesso.'
    within 'nav' do
      expect(page).to have_link 'Entrar'
      expect(page).not_to have_content 'Peter Parker'
      expect(page).not_to have_button 'Sair'
    end
  end
end
