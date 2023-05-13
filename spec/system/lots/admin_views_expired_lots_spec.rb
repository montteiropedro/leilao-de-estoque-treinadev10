require 'rails_helper'

describe 'Admin views expired lots' do
  it 'from menu' do
    first_admin_user = User.create!(
      name: 'John Doe', cpf: '41760209031',
      email: 'john@leilaodogalpao.com.br', password: 'password123'
    )

    login_as(first_admin_user)
    visit root_path
    within('div#lot-menu') do
      click_on 'Listar Lotes Expirados'
    end

    expect(current_path).to eq expired_lots_path
  end

  context 'admin user' do
    it 'should be able to visit expired lots listing page' do
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
      Lot.new(
        code: 'BTC334509', start_date: Date.today - 1.week, end_date: Date.today - 1.day,
        min_bid_in_centavos: 15_000, min_diff_between_bids_in_centavos: 10_000,
        creator: first_admin_user
      ).save!(validate: false)
      Lot.new(
        code: 'ETH801026', start_date: Date.today - 1.week, end_date: Date.today - 1.day,
        min_bid_in_centavos: 15_000, min_diff_between_bids_in_centavos: 10_000,
        creator: first_admin_user, approver: second_admin_user, buyer: user
      ).save!(validate: false)
  
      login_as(first_admin_user)
      visit root_path
      click_on 'Listar Lotes Expirados'
  
      expect(page).to have_content 'Lotes Expirados'
      within('div#lots-expired') do
        expect(page).to have_link 'Lote BTC334509'
      end
      expect(page).to have_content 'Lotes Encerrados'
      within('div#lots-expired-closed') do
        expect(page).to have_link 'ETH801026'
      end
    end

    it 'should see a message when there is no expired lots' do
      admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      Lot.create!(
        code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.week,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: admin_user
      )

      login_as(admin_user)
      visit root_path
      click_on 'Listar Lotes Expirados'
  
      within('div#lots-expired') do
        expect(page).to have_content 'Não existem lotes expirados.'
      end
      within('div#lots-expired-closed') do
        expect(page).to have_content 'Não existem lotes encerrados.'
      end
    end
  end

  context 'visitant' do
    it 'should not be able to visit expired lots listing page' do
      visit expired_lots_path
      
      expect(current_path).not_to eq expired_lots_path
      expect(current_path).to eq new_user_session_path
    end
  end

  context 'non admin user' do
    it 'should not be able to visit expired lots listing page' do
      user = User.create!(
        name: 'Peter Parker', cpf: '73046259026',
        email: 'peter@email.com', password: 'password123'
      )

      login_as(user)
      visit expired_lots_path
      
      expect(current_path).not_to eq expired_lots_path
      expect(current_path).to eq root_path
    end
  end
end
