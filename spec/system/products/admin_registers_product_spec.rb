require 'rails_helper'

describe 'Admin registers a product' do
  it 'from admin menu' do
    admin_user = User.create!(
      name: 'John Doe', cpf: '41760209031',
      email: 'john@leilaodogalpao.com.br', password: 'password123'
    )
    
    login_as(admin_user)
    visit root_path
    within('#product-menu') do
      click_on 'Cadastrar Produto'
    end

    expect(current_path).to eq new_product_path
    expect(page).to have_content 'Cadastrar Novo Produto'
    expect(page).to have_field 'Nome'
    expect(page).to have_field 'Descrição'
    expect(page).to have_field 'Peso'
    expect(page).to have_field 'Largura'
    expect(page).to have_field 'Altura'
    expect(page).to have_field 'Profundidade'
    expect(page).to have_field 'Categoria'
  end

  context 'and is a admin user' do
    it 'should be sucessful with valid data' do
      admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      Category.create!(name: 'Eletrônicos')
  
      login_as(admin_user)
      visit root_path
      click_on 'Cadastrar Produto'

      fill_in 'Nome', with: 'TV 32 Polegadas'
      fill_in 'Descrição', with: 'Televisão Samsung de 32 polegadas'
      fill_in 'Peso', with: 5_000
      fill_in 'Largura', with: 100
      fill_in 'Altura', with: 50
      fill_in 'Profundidade', with: 10
      select 'Eletrônicos', from: 'Categoria'
      click_on 'Cadastrar'

      expect(current_path).to eq product_path(Product.last)
      expect(page).to have_content 'Produto cadastrado com sucesso.'
    end

    it 'should not be sucessful with invalid data' do
      admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
  
      login_as(admin_user)
      visit root_path
      click_on 'Cadastrar Produto'

      fill_in 'Nome', with: ''
      click_on 'Cadastrar'

      expect(current_path).to eq products_path
      expect(page).to have_content 'Falha ao cadastrar o produto.'
    end
  end

  context 'visitant' do
    it 'should be redirected to homepage' do
      visit new_product_path
  
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
      visit new_product_path
  
      expect(current_path).to eq root_path
    end
  end
end
