require 'rails_helper'

describe 'Usuário visita a tela de listagem de produtos' do
  it 'partindo do menu de produtos' do
    visit root_path
    within '#product-menu' do
      click_on 'Listar Produtos'
    end

    expect(current_path).to eq products_path
    expect(page).to have_content('Produtos')
  end

  context 'e quando existem produtos cadastrados na aplicação' do
    it 'deve ser exibido um link para a página de detalhe de cada produto' do
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

    it 'deve ser exibida uma tag com a disponibilidade de cada produto' do
      user = User.create!(
        name: 'Peter Parker', cpf: '73046259026',
        email: 'peter@email.com', password: 'password123'
      )
      admin_user_a = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      admin_user_b = User.create!(
        name: 'Steve Gates', cpf: '35933681024',
        email: 'steve@leilaodogalpao.com.br', password: 'password123'
      )
      approved_lot = Lot.create!(
        code: 'COD123456', start_date: Date.current, end_date: 1.month.from_now,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: admin_user_a, approver: admin_user_b
      )
      sold_lot = Lot.create!(
        code: 'KDA334509', start_date: Date.current, end_date: 1.day.from_now,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 3_000,
        creator: admin_user_a, approver: admin_user_b, buyer: user
      )

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

      travel_to 1.week.from_now do
        visit root_path
        click_on 'Listar Produtos'
      end

      expect(page).to have_content 'Disponível'
      expect(page).to have_content 'Indisponível'
      expect(page).to have_content 'Vendido'
    end
  end

  context 'e quando não existem produtos cadastrados na aplicação' do
    it 'deve vêr uma mensagem' do
      visit root_path
      click_on 'Listar Produtos'

      expect(page).to have_content 'Não existem produtos cadastrados.'
    end
  end
end
