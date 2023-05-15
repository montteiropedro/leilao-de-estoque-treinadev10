require 'rails_helper'

describe 'User visits a categoy details page' do
  it 'from user menu' do
    admin_user = User.create!(
      name: 'John Doe', cpf: '41760209031',
      email: 'john@leilaodogalpao.com.br', password: 'password123'
    )

    login_as(admin_user)
    visit root_path
    within('#category-menu') do
      click_on 'Listar Categorias'
    end

    expect(current_path).to eq categories_path
    expect(page).to have_content 'Categorias'
  end

  it 'should be successful' do
    category = Category.create!(name: 'Eletrônicos')

    visit root_path
    click_on 'Listar Categorias'
    click_on 'Eletrônicos'

    expect(current_path).to eq category_path(category)
    expect(page).to have_content 'Eletrônicos'
  end

  context 'and is a visitant' do
    it 'should not see the button to remove the category' do
      category = Category.create!(name: 'Eletrônicos')

      visit root_path
      click_on 'Listar Categorias'
      click_on 'Eletrônicos'
  
      expect(page).not_to have_button 'Remover Categoria'
    end
  end

  context 'and is not a admin' do
    it 'should not see the button to remove the category' do
      user = User.create!(
        name: 'Peter Parker', cpf: '73046259026',
        email: 'peter@email.com', password: 'password123'
      )
      category = Category.create!(name: 'Eletrônicos')

      login_as(user)
      visit root_path
      click_on 'Listar Categorias'
      click_on 'Eletrônicos'
  
      expect(page).not_to have_button 'Remover Categoria'
    end
  end

  context 'and is a admin' do
    it 'should see the button to remove the category' do
      admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      category = Category.create!(name: 'Eletrônicos')

      login_as(admin_user)
      visit root_path
      click_on 'Listar Categorias'
      click_on 'Eletrônicos'
  
      expect(page).to have_button 'Remover Categoria'
    end
  end
end
