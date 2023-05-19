require 'rails_helper'

describe 'User visits a sold lot' do
  context 'when is a visitant' do
    it 'should be able to visit it' do
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
  
      travel_to 1.week.from_now do
        visit lot_path(lot)
      end
      
      expect(current_path).to eq lot_path(lot)
      expect(page).to have_content 'Adquirido por Peter Parker'
      expect(page).not_to have_content 'Contas suspensas não podem fazer lances.'
    end
  end

  context 'when is not a admin' do
    it 'should be able to visit it through menu when is the buyer' do
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
  
      travel_to 1.week.from_now do
        login_as user
        visit root_path
        within('#lot-menu') do
          click_on 'Listar Lotes Vencidos'
        end
        within('section#lots-won') do
          click_on 'Lote COD123456'
        end
      end
  
      expect(current_path).to eq lot_path(lot)
      expect(page).to have_content 'Adquirido por Peter Parker'
      expect(page).not_to have_content 'Contas suspensas não podem fazer lances.'
    end

    it 'should be able to visit it' do
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
  
      travel_to 1.week.from_now do
        login_as user
        visit lot_path(lot)
      end
      
      expect(current_path).to eq lot_path(lot)
      expect(page).to have_content 'Adquirido por Peter Parker'
      expect(page).not_to have_content 'Contas suspensas não podem fazer lances.'
    end
  end

  context 'when is a admin' do
    it 'should be able to visit it through menu' do
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
  
      travel_to 1.week.from_now do
        login_as admin_user_a
        visit root_path
        within('#lot-menu') do
          click_on 'Listar Lotes Expirados'
        end
        within('section#lots-expired-closed') do
          click_on 'Lote COD123456'
        end
      end
      
      expect(current_path).to eq lot_path(lot)
      expect(page).to have_content 'Adquirido por Peter Parker'
      expect(page).not_to have_content 'Contas suspensas não podem fazer lances.'
    end
  end
end
