require 'rails_helper'

describe 'User visits a expired lot details page' do
  it 'from menu' do
    admin_user = User.create!(
      name: 'John Doe', cpf: '41760209031',
      email: 'john@leilaodogalpao.com.br', password: 'password123'
    )
    lot = Lot.create!(
      code: 'COD123456', start_date: Date.today, end_date: 3.days.from_now,
      min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
      creator: admin_user
    )

    travel_to 1.week.from_now do
      login_as admin_user
      visit root_path
      within('#lot-menu') do
        click_on 'Listar Lotes Expirados'
      end
      within('section#lots-expired') do
        click_on 'Lote COD123456'
      end
    end

    expect(current_path).to eq lot_path(lot)
  end

  context 'when is a visitant' do
    it 'should not be able to visit it' do
      admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      lot = Lot.create!(
        code: 'COD123456', start_date: Date.today, end_date: 3.days.from_now,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: admin_user
      )
  
      travel_to 1.week.from_now do
        visit lot_path(lot)
      end
      
      expect(current_path).not_to eq lot_path(lot)
      expect(current_path).to eq root_path
    end
  end

  context 'when is not a admin' do
    it 'should not be able to visit it' do
      user = User.create!(
        name: 'Peter Parker', cpf: '73046259026',
        email: 'peter@email.com', password: 'password123'
      )
      admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      lot = Lot.create!(
        code: 'COD123456', start_date: Date.today, end_date: 3.days.from_now,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: admin_user
      )
  
      travel_to 1.week.from_now do
        login_as user
        visit lot_path(lot)
      end
      
      expect(current_path).not_to eq lot_path(lot)
      expect(current_path).to eq root_path
    end
  end

  context 'when is a admin' do
    it 'should be successful' do
      admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      lot = Lot.create!(
        code: 'COD123456', start_date: Date.today, end_date: 3.days.from_now,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: admin_user
      )
  
      travel_to 1.week.from_now do
        login_as admin_user
        visit lot_path(lot)
      end
      
      expect(current_path).to eq lot_path(lot)
    end
  end
end
