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

  context 'when successful' do
    it 'should see links to products details page that are related to it' do
      category = Category.create!(name: 'Jogos Eletrônicos')
      Product.create!(
        name: 'Uncharted 3', weight: 300,
        width: 15, height: 30, depth: 5, category: category
      )
      Product.create!(
        name: 'Ghost of Tsushima', weight: 300,
        width: 15, height: 30, depth: 5, category: category
      )
      Product.create!(
        name: 'Grand Theft Auto V', weight: 300,
        width: 15, height: 30, depth: 5, category: category
      )

      visit root_path
      click_on 'Listar Categorias'
      click_on 'Jogos Eletrônicos'

      expect(current_path).to eq category_path(category)
      expect(page).to have_content 'Jogos Eletrônicos'
      expect(page).to have_content 'Uncharted 3'
      expect(page).to have_content 'Ghost of Tsushima'
      expect(page).to have_content 'Grand Theft Auto V'
    end

    it 'should see the products disponibility status' do
      user = User.create!(
        name: 'Peter Parker', cpf: '73046259026',
        email: 'peter@email.com', password: 'password123'
      )
      first_admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      second_admin_user = User.create!(
        name: 'Steve Gates', cpf: '35933681024',
        email: 'steve@leilaodogalpao.com.br', password: 'password123'
      )
      approved_lot = Lot.create!(
        code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.month,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: first_admin_user, approver: second_admin_user
      )
      sold_lot = Lot.new(
        code: 'KDA334509', start_date: Date.today, end_date: Date.today + 1.day,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 3_000,
        creator: first_admin_user, approver: second_admin_user, buyer: user
      )
      sold_lot.save!(validate: false)
      category = Category.create!(name: 'Jogos Eletrônicos')

      Product.create!(
        name: 'Uncharted 3', weight: 300,
        width: 15, height: 30, depth: 5, category: category
      )
      Product.create!(
        name: 'Ghost of Tsushima', weight: 300,
        width: 15, height: 30, depth: 5, category: category,
        lot: approved_lot
      )
      Product.create!(
        name: 'Grand Theft Auto V', weight: 300,
        width: 15, height: 30, depth: 5, category: category,
        lot: sold_lot
      )

      visit root_path
      click_on 'Listar Categorias'
      click_on 'Jogos Eletrônicos'

      expect(page).to have_content 'Disponível'
      expect(page).to have_content 'Indisponível'
      expect(page).to have_content 'Vendido'
    end
  end

  context 'and is a visitant' do
    it 'should not see the button to remove the category' do
      category = Category.create!(name: 'Jogos Eletrônicos')

      visit root_path
      click_on 'Listar Categorias'
      click_on 'Jogos Eletrônicos'
  
      expect(page).not_to have_button 'Remover Categoria'
    end
  end

  context 'and is not a admin' do
    it 'should not see the button to remove the category' do
      user = User.create!(
        name: 'Peter Parker', cpf: '73046259026',
        email: 'peter@email.com', password: 'password123'
      )
      category = Category.create!(name: 'Jogos Eletrônicos')

      login_as(user)
      visit root_path
      click_on 'Listar Categorias'
      click_on 'Jogos Eletrônicos'
  
      expect(page).not_to have_button 'Remover Categoria'
    end
  end

  context 'and is a admin' do
    it 'should see the button to remove the category' do
      admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      category = Category.create!(name: 'Jogos Eletrônicos')

      login_as(admin_user)
      visit root_path
      click_on 'Listar Categorias'
      click_on 'Jogos Eletrônicos'
  
      expect(page).to have_button 'Remover Categoria'
    end
  end
end
