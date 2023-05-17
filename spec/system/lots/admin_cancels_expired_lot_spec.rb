require 'rails_helper'

describe 'Admin cancels a expired lot' do
  it 'should be sucessful' do
    admin_user = User.create!(
      name: 'John Doe', cpf: '41760209031',
      email: 'john@leilaodogalpao.com.br', password: 'password123'
    )
    Lot.create!(
      code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
      min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
      creator: admin_user
    )

    travel_to(Date.today + 1.week) do
      login_as(admin_user)
      visit root_path
      click_on 'Listar Lotes Expirados'
      click_on 'Lote COD123456'
      click_on 'Cancelar Lote'
    end
    
    expect(current_path).to eq expired_lots_path
    expect(page).to have_content 'Lote cancelado com sucesso.'
    within('section#lots-expired') do
      expect(page).not_to have_content 'Lote COD123456'
    end
  end

  context 'when it has products linked to it' do
    it 'should undo the link' do
      admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      lot = Lot.create!(
        code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: admin_user
      )
      product = Product.create!(
        name: 'TV 32 Polegadas', weight: 5_000,
        width: 100, height: 50, depth: 10,
        lot: lot
      )
  
      travel_to(Date.today + 1.week) do
        login_as(admin_user)
        visit lot_path(lot)
        click_on 'Cancelar Lote'
      end
        
      expect(product.reload.lot).to eq nil
    end

    it 'should set the product status to available' do
      admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      lot = Lot.create!(
        code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: admin_user
      )
      product = Product.create!(
        name: 'TV 32 Polegadas', weight: 5_000,
        width: 100, height: 50, depth: 10,
        lot: lot
      )
  
      travel_to(Date.today + 1.week) do
        login_as(admin_user)
        visit lot_path(lot)
        click_on 'Cancelar Lote'
      end
      
      expect(product.reload).to be_available
    end
  end
end
