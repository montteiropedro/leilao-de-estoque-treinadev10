require 'rails_helper'

describe 'User views all registered products' do
  it 'from menu' do
    visit root_path
    within('#product-menu') do
      click_on 'Listar Produtos'
    end

    expect(current_path).to eq products_path
    expect(page).to have_content('Produtos')
  end

  context 'when successful' do
    it 'should see a link to the product details page' do
      Product.create!(
        name: 'TV 32 Polegadas', weight: 5_000,
        width: 100, height: 50, depth: 10
      )
      Product.create!(
        name: 'Quadro', weight: 1_000,
        width: 30, height: 50, depth: 5
      )

      visit root_path
      click_on 'Listar Produtos'

      expect(page).to have_link 'TV 32 Polegadas'
      expect(page).to have_link 'Quadro'
    end

    it 'should see the product disponibility status' do
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
        code: 'KDA334509', start_date: Date.today - 2.weeks, end_date: Date.today - 1.week,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 3_000,
        creator: first_admin_user, approver: second_admin_user, buyer: user
      )
      sold_lot.save!(validate: false)

      Product.create!(
        name: 'TV 32 Polegadas', weight: 5_000,
        width: 100, height: 50, depth: 10
      )
      Product.create!(
        name: 'Teclado Mecânico', weight: 1_000,
        width: 30, height: 10, depth: 3,
        lot: approved_lot
      )
      Product.create!(
        name: 'Webcam C720 Logitech', weight: 500,
        width: 100, height: 50, depth: 10,
        lot: sold_lot
      )

      visit root_path
      click_on 'Listar Produtos'

      expect(page).to have_content 'Disponível'
      expect(page).to have_content 'Indisponível'
      expect(page).to have_content 'Vendido'
    end
  end

  

  it 'and should see a message when there is no product registered' do
    visit root_path
    click_on 'Listar Produtos'

    expect(page).to have_content 'Não existem produtos cadastrados.'
  end
end
