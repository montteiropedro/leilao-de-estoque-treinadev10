require 'rails_helper'

describe 'Administrador cadastra uma categoria de produto' do
  it 'partindo do menu de categorias' do
    admin_user = User.create!(
      name: 'John Doe', cpf: '41760209031',
      email: 'john@leilaodogalpao.com.br', password: 'password123'
    )

    login_as admin_user
    visit root_path
    within '#category-menu' do
      click_on 'Cadastrar Categoria'
    end

    expect(current_path).to eq new_category_path
    expect(page).to have_content 'Cadastrar Nova Categoria'
    expect(page).to have_field 'Nome'
  end

  it 'com sucesso quando utiliza dados válidos' do
    admin_user = User.create!(
      name: 'John Doe', cpf: '41760209031',
      email: 'john@leilaodogalpao.com.br', password: 'password123'
    )

    login_as admin_user
    visit root_path
    click_on 'Cadastrar Categoria'
    fill_in 'Nome', with: 'Eletrônicos'
    click_on 'Cadastrar'

    expect(current_path).to eq category_path(Category.last)
    expect(page).to have_content 'Categoria cadastrada com sucesso.'
  end

  it 'sem sucesso quando utiliza dados inválidos' do
    admin_user = User.create!(
      name: 'John Doe', cpf: '41760209031',
      email: 'john@leilaodogalpao.com.br', password: 'password123'
    )

    login_as admin_user
    visit root_path
    click_on 'Cadastrar Categoria'
    fill_in 'Nome', with: ''
    click_on 'Cadastrar'

    expect(current_path).to eq categories_path
    expect(page).to have_content 'Falha ao cadastrar a categoria.'
  end
end
