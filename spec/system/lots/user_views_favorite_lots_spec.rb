require 'rails_helper'

describe 'User views his/her favorite lots' do
  it 'from menu' do
    user = User.create!(
      name: 'Peter Parker', cpf: '73046259026',
      email: 'peter@email.com', password: 'password123'
    )

    login_as user
    visit root_path
    within('nav') do
      click_on 'Lotes Favoritos'
    end

    expect(current_path).to eq favorite_lots_path
  end

  it 'and should be successful' do
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
    lot_a = Lot.create!(
      code: 'COD123456', start_date: Date.today, end_date: 3.days.from_now,
      min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
      creator: admin_user_a, approver: admin_user_b
    )
    lot_b = Lot.create!(
      code: 'BTC334509', start_date: Date.today, end_date: 3.days.from_now,
      min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
      creator: admin_user_a, approver: admin_user_b
    )
    user.favorite_lots << lot_a

    login_as user
    visit root_path
    click_on 'Lotes Favoritos'

    expect(page).to have_css 'h1', text: 'Lotes Favoritos'
    within('section#lots-favorite') do
      expect(page).to have_link 'Lote COD123456'
      expect(page).not_to have_link 'Lote BTC334509'
    end
  end

  it 'and should see a expired tag when a favorite lot is expired' do
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
    lot = Lot.create!(
      code: 'COD123456', start_date: Date.today, end_date: 3.days.from_now,
      min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
      creator: admin_user_a, approver: admin_user_b
    )
    user.favorite_lots << lot

    travel_to 1.week.from_now do
      login_as user
      visit root_path
      click_on 'Lotes Favoritos'
    end

    expect(page).to have_content 'Expirado'
  end

  it 'and should see a sold tag when a favorite lot is sold' do
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
    lot = Lot.create!(
      code: 'COD123456', start_date: Date.today, end_date: 3.days.from_now,
      min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
      creator: admin_user_a, approver: admin_user_b, buyer: user
    )
    user.favorite_lots << lot

    travel_to 1.week.from_now do
      login_as user
      visit root_path
      click_on 'Lotes Favoritos'
    end

    expect(page).to have_content 'Vendido'
  end

  it 'and should see a message when there is no favorite lots' do
    user = User.create!(
      name: 'Peter Parker', cpf: '73046259026',
      email: 'peter@email.com', password: 'password123'
    )

    login_as user
    visit root_path
    click_on 'Lotes Favoritos'

    expect(page).to have_content 'Você não adicionou nenhum lote aos favoritos ainda.'
  end

  context 'visitant' do
    it 'should not be able to visit favorite lots listing page' do
      visit favorite_lots_path
  
      expect(current_path).not_to eq favorite_lots_path
      expect(current_path).to eq new_user_session_path
    end
  end
end
