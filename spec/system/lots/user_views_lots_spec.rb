require 'rails_helper'

describe 'User views all registered lots' do
  it 'from menu' do
    visit root_path
    within('#lot-menu') do
      click_on 'Listar Lotes'
    end

    expect(current_path).to eq lots_path
  end

  it 'should see a search bar to search for products linked to it at the listing page' do
    admin_user = User.create!(
      name: 'John Doe', cpf: '41760209031',
      email: 'john@leilaodogalpao.com.br', password: 'password123'
    )
    lot = Lot.create!(
      code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
      min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
      creator: admin_user
    )

    visit lots_path

    within('form#search-lots') do
      expect(page).to have_field 'Pesquisar lote pelo código ou produto vinculado'
      expect(page).to have_button 'Pesquisar'
    end
  end

  context 'and is a visitant' do
    it 'should see approved lots in progress' do
      first_admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      second_admin_user = User.create!(
        name: 'Steve Gates', cpf: '35933681024',
        email: 'steve@leilaodogalpao.com.br', password: 'password123'
      )
      Lot.create!(
        code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.week,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: first_admin_user, approver: second_admin_user
      )
  
      visit root_path
      click_on 'Listar Lotes'
  
      expect(page).to have_content 'Lotes Aprovados'
      within('section#lots-in-progress') do
        expect(page).to have_link 'Lote COD123456'
      end
    end

    it 'should see a message when there is no approved lots in progress' do
      first_admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      second_admin_user = User.create!(
        name: 'Steve Gates', cpf: '35933681024',
        email: 'steve@leilaodogalpao.com.br', password: 'password123'
      )
      Lot.create!(
        code: 'COD123456', start_date: Date.today + 1.week, end_date: Date.today + 2.week,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: first_admin_user, approver: second_admin_user
      )

      visit root_path
      click_on 'Listar Lotes'
  
      expect(page).to have_content 'Não existem lotes aprovados em andamento.'
    end

    it 'should see approved lots waiting for start' do
      first_admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      second_admin_user = User.create!(
        name: 'Steve Gates', cpf: '35933681024',
        email: 'steve@leilaodogalpao.com.br', password: 'password123'
      )
      Lot.create!(
        code: 'COD123456', start_date: Date.today + 1.week, end_date: Date.today + 2.week,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: first_admin_user, approver: second_admin_user
      )
  
      visit root_path
      click_on 'Listar Lotes'
  
      expect(page).to have_content 'Lotes Aprovados'
      within('section#lots-waiting-start') do
        expect(page).to have_link 'Lote COD123456'
      end
    end

    it 'should see a message when there is no approved lots waiting for start' do
      first_admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      second_admin_user = User.create!(
        name: 'Steve Gates', cpf: '35933681024',
        email: 'steve@leilaodogalpao.com.br', password: 'password123'
      )
      Lot.create!(
        code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.week,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: first_admin_user, approver: second_admin_user
      )

      visit root_path
      click_on 'Listar Lotes'
  
      expect(page).to have_content 'Não existem lotes aprovados preparados para o futuro.'
    end
    
    it 'should not see lots awaiting approval' do
      first_admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      Lot.create!(
        code: 'BTC334509', start_date: Date.today, end_date: Date.today + 1.day,
        min_bid_in_centavos: 15_000, min_diff_between_bids_in_centavos: 10_000,
        creator: first_admin_user
      )
  
      visit root_path
      click_on 'Listar Lotes'
  
      expect(page).not_to have_content 'Lotes Aguardando Aprovação'
      expect(page).not_to have_link 'Lote BTC334509'
    end

    it 'should not see a message when there is no lots awaiting approval registered' do
      visit root_path
      click_on 'Listar Lotes'
  
      expect(page).not_to have_content 'Não existem lotes cadastrados/aguardando aprovação.'
    end

    it 'should not see expired lots' do
      first_admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      Lot.new(
        code: 'BTC334509', start_date: Date.today - 1.week, end_date: Date.today - 1.day,
        min_bid_in_centavos: 15_000, min_diff_between_bids_in_centavos: 10_000,
        creator: first_admin_user
      ).save!(validate: false)
  
      visit root_path
      click_on 'Listar Lotes'
  
      expect(page).not_to have_content 'Lotes Expirados'
      expect(page).not_to have_link 'Lote BTC334509'
    end
  end

  context 'and is not a admin' do
    it 'should see approved lots in progress' do
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
      Lot.create!(
        code: 'COD123456', start_date: Date.today, end_date: Date.today + 1,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: first_admin_user, approver: second_admin_user
      )
  
      login_as(user)
      visit root_path
      click_on 'Listar Lotes'
      
      expect(page).to have_content 'Lotes Aprovados'
      within('section#lots-in-progress') do
        expect(page).to have_link 'Lote COD123456'
      end
    end

    it 'should see a message when there is no approved lots in progress' do
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
      Lot.create!(
        code: 'COD123456', start_date: Date.today + 1.week, end_date: Date.today + 2.week,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: first_admin_user, approver: second_admin_user
      )

      login_as(user)
      visit root_path
      click_on 'Listar Lotes'
  
      expect(page).to have_content 'Não existem lotes aprovados em andamento.'
    end

    it 'should see approved lots waiting for start' do
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
      Lot.create!(
        code: 'COD123456', start_date: Date.today + 1.week, end_date: Date.today + 2.weeks,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: first_admin_user, approver: second_admin_user
      )
  
      login_as(user)
      visit root_path
      click_on 'Listar Lotes'
      
      expect(page).to have_content 'Lotes Aprovados'
      within('section#lots-waiting-start') do
        expect(page).to have_link 'Lote COD123456'
      end
    end

    it 'should see a message when there is no approved lots waiting for start' do
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
      Lot.create!(
        code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.week,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: first_admin_user, approver: second_admin_user
      )

      login_as(user)
      visit root_path
      click_on 'Listar Lotes'
  
      expect(page).to have_content 'Não existem lotes aprovados preparados para o futuro.'
    end
    
    it 'should not see lots awaiting approval' do
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
      Lot.create!(
        code: 'BTC334509', start_date: Date.today, end_date: Date.today + 1,
        min_bid_in_centavos: 15_000, min_diff_between_bids_in_centavos: 10_000,
        creator: first_admin_user
      )
  
      login_as(user)
      visit root_path
      click_on 'Listar Lotes'

      expect(page).not_to have_content 'Lotes Aguardando Aprovação'
      expect(page).not_to have_link 'Lote BTC334509'
    end

    it 'should not see a message when there is no lots awaiting approval registered' do
      user = User.create!(
        name: 'Peter Parker', cpf: '73046259026',
        email: 'peter@email.com', password: 'password123'
      )

      login_as(user)
      visit root_path
      click_on 'Listar Lotes'
  
      expect(page).not_to have_content 'Não existem lotes cadastrados/aguardando aprovação.'
    end

    it 'should not see expired lots' do
      user = User.create!(
        name: 'Peter Parker', cpf: '73046259026',
        email: 'peter@email.com', password: 'password123'
      )
      first_admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      Lot.new(
        code: 'BTC334509', start_date: Date.today - 1.week, end_date: Date.today - 1.day,
        min_bid_in_centavos: 15_000, min_diff_between_bids_in_centavos: 10_000,
        creator: first_admin_user
      ).save!(validate: false)
  
      login_as(user)
      visit root_path
      click_on 'Listar Lotes'
  
      expect(page).not_to have_content 'Lotes Expirados'
      expect(page).not_to have_link 'Lote BTC334509'
    end
  end

  context 'and is a admin' do
    it 'should see lots awaiting approval that are not expired' do
      admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      Lot.new(
        code: 'COD123456', start_date: Date.today - 1.day, end_date: Date.today + 1.day,
        min_bid_in_centavos: 15_000, min_diff_between_bids_in_centavos: 10_000,
        creator: admin_user
      ).save!(validate: false)
      Lot.new(
        code: 'BTC334509', start_date: Date.today - 1.week, end_date: Date.today - 1.day,
        min_bid_in_centavos: 15_000, min_diff_between_bids_in_centavos: 10_000,
        creator: admin_user
      ).save!(validate: false)
  
      login_as(admin_user)
      visit root_path
      click_on 'Listar Lotes'
      
      expect(page).to have_content 'Lotes Aguardando Aprovação'
      within('section#lots-awaiting-approval') do
        expect(page).to have_link 'Lote COD123456'
        expect(page).not_to have_link 'Lote BTC334509'
      end
    end

    it 'should see a message when there is no lots awaiting approval registered' do
      first_admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )

      login_as(first_admin_user)
      visit root_path
      click_on 'Listar Lotes'
  
      within('section#lots-awaiting-approval') do
        expect(page).to have_content 'Não existem lotes aguardando aprovação.'
      end
    end

    it 'should see approved lots in progress' do
      first_admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      second_admin_user = User.create!(
        name: 'Steve Gates', cpf: '35933681024',
        email: 'steve@leilaodogalpao.com.br', password: 'password123'
      )
      Lot.create!(
        code: 'COD123456', start_date: Date.today, end_date: Date.today + 1,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: first_admin_user, approver: second_admin_user
      )
  
      login_as(first_admin_user)
      visit root_path
      click_on 'Listar Lotes'
  
      expect(page).to have_content 'Lotes Aprovados'
      within('section#lots-in-progress') do
        expect(page).to have_link 'Lote COD123456'
      end
    end

    it 'should see a message when there is no approved lots in progress' do
      first_admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      second_admin_user = User.create!(
        name: 'Steve Gates', cpf: '35933681024',
        email: 'steve@leilaodogalpao.com.br', password: 'password123'
      )
      Lot.create!(
        code: 'COD123456', start_date: Date.today + 1.week, end_date: Date.today + 2.week,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: first_admin_user, approver: second_admin_user
      )

      login_as(first_admin_user)
      visit root_path
      click_on 'Listar Lotes'
  
      expect(page).to have_content 'Não existem lotes aprovados em andamento.'
    end

    it 'should see approved lots waiting for start' do
      first_admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      second_admin_user = User.create!(
        name: 'Steve Gates', cpf: '35933681024',
        email: 'steve@leilaodogalpao.com.br', password: 'password123'
      )
      Lot.create!(
        code: 'COD123456', start_date: Date.today + 1.week, end_date: Date.today + 2.weeks,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: first_admin_user, approver: second_admin_user
      )
  
      login_as(first_admin_user)
      visit root_path
      click_on 'Listar Lotes'
  
      expect(page).to have_content 'Lotes Aprovados'
      within('section#lots-waiting-start') do
        expect(page).to have_link 'Lote COD123456'
      end
    end

    it 'should see a message when there is no approved lots waiting for start' do
      first_admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      second_admin_user = User.create!(
        name: 'Steve Gates', cpf: '35933681024',
        email: 'steve@leilaodogalpao.com.br', password: 'password123'
      )
      Lot.create!(
        code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.week,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: first_admin_user, approver: second_admin_user
      )

      login_as(first_admin_user)
      visit root_path
      click_on 'Listar Lotes'
  
      expect(page).to have_content 'Não existem lotes aprovados preparados para o futuro.'
    end

    it 'should not see expired lots' do
      first_admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      Lot.new(
        code: 'BTC334509', start_date: Date.today - 1.week, end_date: Date.today - 1.day,
        min_bid_in_centavos: 15_000, min_diff_between_bids_in_centavos: 10_000,
        creator: first_admin_user
      ).save!(validate: false)
  
      login_as(first_admin_user)
      visit root_path
      click_on 'Listar Lotes'
  
      expect(page).not_to have_content 'Lotes Expirados'
      expect(page).not_to have_link 'Lote BTC334509'
    end
  end
end
