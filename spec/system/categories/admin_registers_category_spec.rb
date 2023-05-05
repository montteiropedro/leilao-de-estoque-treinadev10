require 'rails_helper'

describe 'Admin registers a category' do
  it 'from admin menu' do
    admin_user = User.create!(
      name: 'John Doe', cpf: '41760209031',
      email: 'john@leilaodogalpao.com.br', password: 'password123'
    )

    login_as(admin_user)
    visit root_path
    within('#category-menu') do
      click_on 'Cadastrar Categoria'
    end

    expect(current_path).to eq new_category_path
    expect(page).to have_content 'Cadastrar Nova Categoria'
    expect(page).to have_field 'Nome'
  end

  context 'admin user' do
    it 'should be sucessful with valid data' do
      admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
  
      login_as(admin_user)
      visit root_path
      click_on 'Cadastrar Categoria'
      fill_in 'Nome', with: 'Eletrônicos'
      click_on 'Cadastrar'

      expect(current_path).to eq category_path(Category.last)
      expect(page).to have_content 'Categoria cadastrada com sucesso.'
    end

    it 'should not be sucessful with invalid data' do
      admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
  
      login_as(admin_user)
      visit root_path
      click_on 'Cadastrar Categoria'
      fill_in 'Nome', with: ''
      click_on 'Cadastrar'

      expect(current_path).to eq categories_path
      expect(page).to have_content 'Falha ao cadastrar a categoria.'
    end
  end

  context 'visitant' do
    it 'should be redirected to homepage' do
      visit new_category_path
  
      expect(current_path).to eq new_user_session_path
    end
  end

  context 'non admin user' do
    it 'should be redirected to homepage' do
      user = User.create!(
        name: 'Peter Parker', cpf: '73046259026',
        email: 'peter@email.com', password: 'password123'
      )
  
      login_as(user)
      visit new_category_path
  
      expect(current_path).to eq root_path
    end
  end
end
