require 'rails_helper'

describe 'Admin views expired batches' do
  it 'from menu' do
    first_admin_user = User.create!(
      name: 'John Doe', cpf: '41760209031',
      email: 'john@leilaodogalpao.com.br', password: 'password123'
    )

    login_as(first_admin_user)
    visit root_path
    within('div#batch-menu') do
      click_on 'Listar Lotes Expirados'
    end

    expect(current_path).to eq expired_batches_path
  end

  context 'admin user' do
    it 'should be able to visit expired batches listing page' do
      first_admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      Batch.new(
        code: 'BTC334509', start_date: Date.today - 1.week, end_date: Date.today - 1.day,
        min_bid_in_centavos: 15_000, min_diff_between_bids_in_centavos: 10_000,
        creator: first_admin_user
      ).save!(validate: false)
  
      login_as(first_admin_user)
      visit root_path
      click_on 'Listar Lotes Expirados'
  
      expect(page).to have_content 'Lotes Expirados'
      within('div#batches-expired') do
        expect(page).to have_link 'Lote BTC334509'
      end
    end

    it 'should see a message when there is no expired batches' do
      first_admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      Batch.create!(
        code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.week,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: first_admin_user
      )

      login_as(first_admin_user)
      visit root_path
      click_on 'Listar Lotes Expirados'
  
      expect(page).to have_content 'Não existem lotes expirados.'
    end
  end

  context 'visitant' do
    it 'should not be able to visit expired batches listing page' do
      visit expired_batches_path
      
      expect(current_path).not_to eq expired_batches_path
      expect(current_path).to eq new_user_session_path
    end
  end

  context 'non admin user' do
    it 'should not be able to visit expired batches listing page' do
      user = User.create!(
        name: 'Peter Parker', cpf: '73046259026',
        email: 'peter@email.com', password: 'password123'
      )

      login_as(user)
      visit expired_batches_path
      
      expect(current_path).not_to eq expired_batches_path
      expect(current_path).to eq root_path
    end
  end
end
