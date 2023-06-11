require 'rails_helper'

describe 'Administrador cadastrar um produto' do
  it 'partindo do menu administrativo' do
    admin_user = User.create!(
      name: 'John Doe', cpf: '41760209031',
      email: 'john@leilaodogalpao.com.br', password: 'password123'
    )

    login_as admin_user
    visit root_path
    within '#product-menu' do
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

  it 'com sucesso quando utiliza dados válidos' do
    admin_user = User.create!(
      name: 'John Doe', cpf: '41760209031',
      email: 'john@leilaodogalpao.com.br', password: 'password123'
    )
    Category.create!(name: 'Eletrônicos')

    login_as admin_user
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

  it 'sem sucesso quando utiliza dados inválidos' do
    admin_user = User.create!(
      name: 'John Doe', cpf: '41760209031',
      email: 'john@leilaodogalpao.com.br', password: 'password123'
    )

    login_as admin_user
    visit root_path
    click_on 'Cadastrar Produto'
    fill_in 'Nome', with: ''
    click_on 'Cadastrar'

    expect(current_path).to eq products_path
    expect(page).to have_content 'Falha ao cadastrar o produto.'
  end
end
