require 'rails_helper'

describe 'Admin closes a expired lot' do
  it 'should be sucessful' do
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
    lot = Lot.create!(
      code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
      min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
      creator: first_admin_user, approver: second_admin_user
    )
    Bid.create!(value_in_centavos: 10_500, user: user, lot: lot)

    travel_to(Date.today + 1.week) do
      login_as(first_admin_user)
      visit root_path
      click_on 'Listar Lotes Expirados'
      click_on 'Lote COD123456'
      click_on 'Encerrar Lote'
    end
    
    expect(current_path).to eq expired_lots_path
    expect(page).to have_content 'Lote encerrado com sucesso.'
    within('section#lots-expired') do
      expect(page).not_to have_content 'Lote COD123456'
    end
    within('section#lots-expired-closed') do
      expect(page).to have_content 'Lote COD123456'
    end
  end

  context 'when it has products linked to it' do
    it 'should not undo the link' do
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
      lot = Lot.create!(
        code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: first_admin_user, approver: second_admin_user
      )
      product = Product.create!(
        name: 'TV 32 Polegadas', weight: 5_000,
        width: 100, height: 50, depth: 10,
        lot: lot
      )
      Bid.create!(value_in_centavos: 10_500, user: user, lot: lot)
  
      travel_to(Date.today + 1.week) do
        login_as(first_admin_user)
        visit lot_path(lot)
        click_on 'Encerrar Lote'
      end
        
      expect(product.reload.lot).to eq lot
    end

    it 'should set the product status to available' do
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
      lot = Lot.create!(
        code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: first_admin_user, approver: second_admin_user
      )
      product = Product.create!(
        name: 'TV 32 Polegadas', weight: 5_000,
        width: 100, height: 50, depth: 10,
        lot: lot
      )
      Bid.create!(value_in_centavos: 10_500, user: user, lot: lot)
  
      travel_to(Date.today + 1.week) do
        login_as(first_admin_user)
        visit lot_path(lot)
        click_on 'Encerrar Lote'
      end
      
      expect(product.reload).to be_sold
    end
  end
end
