require 'rails_helper'

describe 'Usuário visita a página de detalhes de uma categoria de produto' do
  it 'a partir do menu de categorias' do
    category = Category.create!(name: 'Jogos Eletrônicos')

    visit root_path
    within '#category-menu' do
      click_on 'Listar Categorias'
    end
    click_on 'Jogos Eletrônicos'

    expect(current_path).to eq category_path(category)
    expect(page).to have_content 'Jogos Eletrônicos'
  end

  context 'e quando existem produtos relacionados a categoria' do
    it 'deve ser exibido um link para a página de detalhes de cada produto' do
      category = Category.create!(name: 'Jogos Eletrônicos')
      Product.create!(
        name: 'Uncharted 3', weight: 300,
        width: 15, height: 30, depth: 5, category:
      )
      Product.create!(
        name: 'Ghost of Tsushima', weight: 300,
        width: 15, height: 30, depth: 5, category:
      )
      Product.create!(
        name: 'Grand Theft Auto V', weight: 300,
        width: 15, height: 30, depth: 5, category:
      )

      visit category_path(category)

      expect(current_path).to eq category_path(category)
      expect(page).to have_content 'Jogos Eletrônicos'
      expect(page).to have_link 'Uncharted 3'
      expect(page).to have_link 'Ghost of Tsushima'
      expect(page).to have_link 'Grand Theft Auto V'
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
      sold_lot = Lot.new(
        code: 'KDA334509', start_date: Date.current, end_date: 1.day.from_now,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 3_000,
        creator: admin_user_a, approver: admin_user_b, buyer: user
      )
      sold_lot.save!(validate: false)
      category = Category.create!(name: 'Jogos Eletrônicos')
      Product.create!(
        name: 'Uncharted 3', weight: 300,
        width: 15, height: 30, depth: 5, category:
      )
      Product.create!(
        name: 'Ghost of Tsushima', weight: 300,
        width: 15, height: 30, depth: 5, category:, lot: approved_lot
      )
      Product.create!(
        name: 'Grand Theft Auto V', weight: 300,
        width: 15, height: 30, depth: 5, category:, lot: sold_lot
      )

      travel_to 1.week.from_now do
        visit category_path(category)
      end

      expect(page).to have_content 'Disponível'
      expect(page).to have_content 'Indisponível'
      expect(page).to have_content 'Vendido'
    end
  end
end
