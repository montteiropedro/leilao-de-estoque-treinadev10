require 'rails_helper'

describe 'Usuário acessa a página de cadastro' do
  it 'através da barra de navegação' do
    visit root_path
    within 'nav' do
      click_on 'Inscrever-se'
    end

    expect(current_path).to eq new_user_registration_path
    within 'form' do
      expect(page).to have_content 'Nome'
      expect(page).to have_content 'CPF'
      expect(page).to have_content 'E-mail'
      expect(page).to have_content 'Senha'
      expect(page).to have_content 'Confirme sua senha'
    end
  end

  it 'através da página de login' do
    visit root_path
    within('nav') do
      click_on 'Entrar'
    end
    within('main') do
      click_on 'Inscrever-se'
    end

    expect(current_path).to eq new_user_registration_path

    within('form') do
      expect(page).to have_content 'Nome'
      expect(page).to have_content 'CPF'
      expect(page).to have_content 'E-mail'
      expect(page).to have_content 'Senha'
      expect(page).to have_content 'Confirme sua senha'
    end
  end

  it 'e consegue se cadastrar com dados válidos' do
    visit root_path
    click_on 'Inscrever-se'
    within('form') do
      fill_in('Nome', with: 'Peter Parker')
      fill_in 'CPF', with: '73046259026'
      fill_in 'E-mail', with: 'peter@email.com'
      fill_in 'Senha', with: 'password123'
      fill_in 'Confirme sua senha', with: 'password123'
      click_on 'Cadastrar'
    end

    expect(current_path).to eq root_path
    expect(page).to have_content 'Cadastro realizado com sucesso.'
    expect(User.last.name).to eq 'Peter Parker'
    within('nav') do
      expect(page).to have_content 'Peter Parker'
      expect(page).to have_content 'Sair'
    end
  end

  it 'e não consegue se cadastrar com dados inválidos' do
    visit root_path
    click_on 'Inscrever-se'
    fill_in 'Nome', with: 'Peter Parker'
    fill_in 'CPF', with: '73046'
    fill_in 'E-mail', with: 'peteremail.com'
    fill_in 'Senha', with: 'pass1'
    fill_in 'Confirme sua senha', with: 'pass1'
    click_on 'Cadastrar'

    expect(current_path).to eq user_registration_path
    expect(page).to have_content 'Não foi possível salvar usuário:'
  end

  it 'e não consegue se cadastrar quando seu CPF está bloqueado na aplicação' do
    BlockedCpf.create!(cpf: '73046259026')

    visit new_user_registration_path
    fill_in 'CPF', with: '73046259026'
    click_on 'Cadastrar'

    expect(current_path).to eq user_registration_path
    expect(page).to have_content 'Não foi possível salvar usuário:'
    expect(page).to have_content 'CPF bloqueado'
  end
end
