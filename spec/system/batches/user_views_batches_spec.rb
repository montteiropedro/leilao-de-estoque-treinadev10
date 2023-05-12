require 'rails_helper'

describe 'User views all registered batches' do
  it 'from menu' do
    visit root_path
    within('#batch-menu') do
      click_on 'Listar Lotes'
    end

    expect(current_path).to eq batches_path
  end

  context 'and is a visitant' do
    it 'should see approved batches in progress' do
      first_admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      second_admin_user = User.create!(
        name: 'Steve Gates', cpf: '35933681024',
        email: 'steve@leilaodogalpao.com.br', password: 'password123'
      )
      Batch.create!(
        code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.week,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: first_admin_user, approver: second_admin_user
      )
  
      visit root_path
      click_on 'Listar Lotes'
  
      expect(page).to have_content 'Lotes Aprovados'
      within('div#batches-in-progress') do
        expect(page).to have_link 'Lote COD123456'
      end
    end

    it 'should see a message when there is no approved batches in progress' do
      first_admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      second_admin_user = User.create!(
        name: 'Steve Gates', cpf: '35933681024',
        email: 'steve@leilaodogalpao.com.br', password: 'password123'
      )
      Batch.create!(
        code: 'COD123456', start_date: Date.today + 1.week, end_date: Date.today + 2.week,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: first_admin_user, approver: second_admin_user
      )

      visit root_path
      click_on 'Listar Lotes'
  
      expect(page).to have_content 'Não existem lotes aprovados em andamento.'
    end

    it 'should see approved batches waiting for start' do
      first_admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      second_admin_user = User.create!(
        name: 'Steve Gates', cpf: '35933681024',
        email: 'steve@leilaodogalpao.com.br', password: 'password123'
      )
      Batch.create!(
        code: 'COD123456', start_date: Date.today + 1.week, end_date: Date.today + 2.week,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: first_admin_user, approver: second_admin_user
      )
  
      visit root_path
      click_on 'Listar Lotes'
  
      expect(page).to have_content 'Lotes Aprovados'
      within('div#batches-waiting-start') do
        expect(page).to have_link 'Lote COD123456'
      end
    end

    it 'should see a message when there is no approved batches waiting for start' do
      first_admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      second_admin_user = User.create!(
        name: 'Steve Gates', cpf: '35933681024',
        email: 'steve@leilaodogalpao.com.br', password: 'password123'
      )
      Batch.create!(
        code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.week,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: first_admin_user, approver: second_admin_user
      )

      visit root_path
      click_on 'Listar Lotes'
  
      expect(page).to have_content 'Não existem lotes aprovados preparados para o futuro.'
    end
    
    it 'should not see batches awaiting approval' do
      first_admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      Batch.create!(
        code: 'BTC334509', start_date: Date.today, end_date: Date.today + 1.day,
        min_bid_in_centavos: 15_000, min_diff_between_bids_in_centavos: 10_000,
        creator: first_admin_user
      )
  
      visit root_path
      click_on 'Listar Lotes'
  
      expect(page).not_to have_content 'Lotes Aguardando Aprovação'
      expect(page).not_to have_link 'Lote BTC334509'
    end

    it 'should not see a message when there is no batches awaiting approval registered' do
      visit root_path
      click_on 'Listar Lotes'
  
      expect(page).not_to have_content 'Não existem lotes cadastrados/aguardando aprovação.'
    end

    it 'should not see expired batches' do
      first_admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      Batch.new(
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
    it 'should see approved batches in progress' do
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
      Batch.create!(
        code: 'COD123456', start_date: Date.today, end_date: Date.today + 1,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: first_admin_user, approver: second_admin_user
      )
  
      login_as(user)
      visit root_path
      click_on 'Listar Lotes'
      
      expect(page).to have_content 'Lotes Aprovados'
      within('div#batches-in-progress') do
        expect(page).to have_link 'Lote COD123456'
      end
    end

    it 'should see a message when there is no approved batches in progress' do
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
      Batch.create!(
        code: 'COD123456', start_date: Date.today + 1.week, end_date: Date.today + 2.week,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: first_admin_user, approver: second_admin_user
      )

      login_as(user)
      visit root_path
      click_on 'Listar Lotes'
  
      expect(page).to have_content 'Não existem lotes aprovados em andamento.'
    end

    it 'should see approved batches waiting for start' do
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
      Batch.create!(
        code: 'COD123456', start_date: Date.today + 1.week, end_date: Date.today + 2.weeks,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: first_admin_user, approver: second_admin_user
      )
  
      login_as(user)
      visit root_path
      click_on 'Listar Lotes'
      
      expect(page).to have_content 'Lotes Aprovados'
      within('div#batches-waiting-start') do
        expect(page).to have_link 'Lote COD123456'
      end
    end

    it 'should see a message when there is no approved batches waiting for start' do
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
      Batch.create!(
        code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.week,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: first_admin_user, approver: second_admin_user
      )

      login_as(user)
      visit root_path
      click_on 'Listar Lotes'
  
      expect(page).to have_content 'Não existem lotes aprovados preparados para o futuro.'
    end
    
    it 'should not see batches awaiting approval' do
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
      Batch.create!(
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

    it 'should not see a message when there is no batches awaiting approval registered' do
      user = User.create!(
        name: 'Peter Parker', cpf: '73046259026',
        email: 'peter@email.com', password: 'password123'
      )

      login_as(user)
      visit root_path
      click_on 'Listar Lotes'
  
      expect(page).not_to have_content 'Não existem lotes cadastrados/aguardando aprovação.'
    end

    it 'should not see expired batches' do
      user = User.create!(
        name: 'Peter Parker', cpf: '73046259026',
        email: 'peter@email.com', password: 'password123'
      )
      first_admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      Batch.new(
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
    it 'should see approved batches in progress' do
      first_admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      second_admin_user = User.create!(
        name: 'Steve Gates', cpf: '35933681024',
        email: 'steve@leilaodogalpao.com.br', password: 'password123'
      )
      Batch.create!(
        code: 'COD123456', start_date: Date.today, end_date: Date.today + 1,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: first_admin_user, approver: second_admin_user
      )
  
      login_as(first_admin_user)
      visit root_path
      click_on 'Listar Lotes'
  
      expect(page).to have_content 'Lotes Aprovados'
      within('div#batches-in-progress') do
        expect(page).to have_link 'Lote COD123456'
      end
    end

    it 'should see a message when there is no approved batches in progress' do
      first_admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      second_admin_user = User.create!(
        name: 'Steve Gates', cpf: '35933681024',
        email: 'steve@leilaodogalpao.com.br', password: 'password123'
      )
      Batch.create!(
        code: 'COD123456', start_date: Date.today + 1.week, end_date: Date.today + 2.week,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: first_admin_user, approver: second_admin_user
      )

      login_as(first_admin_user)
      visit root_path
      click_on 'Listar Lotes'
  
      expect(page).to have_content 'Não existem lotes aprovados em andamento.'
    end

    it 'should see approved batches waiting for start' do
      first_admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      second_admin_user = User.create!(
        name: 'Steve Gates', cpf: '35933681024',
        email: 'steve@leilaodogalpao.com.br', password: 'password123'
      )
      Batch.create!(
        code: 'COD123456', start_date: Date.today + 1.week, end_date: Date.today + 2.weeks,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: first_admin_user, approver: second_admin_user
      )
  
      login_as(first_admin_user)
      visit root_path
      click_on 'Listar Lotes'
  
      expect(page).to have_content 'Lotes Aprovados'
      within('div#batches-waiting-start') do
        expect(page).to have_link 'Lote COD123456'
      end
    end

    it 'should see a message when there is no approved batches waiting for start' do
      first_admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      second_admin_user = User.create!(
        name: 'Steve Gates', cpf: '35933681024',
        email: 'steve@leilaodogalpao.com.br', password: 'password123'
      )
      Batch.create!(
        code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.week,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: first_admin_user, approver: second_admin_user
      )

      login_as(first_admin_user)
      visit root_path
      click_on 'Listar Lotes'
  
      expect(page).to have_content 'Não existem lotes aprovados preparados para o futuro.'
    end
    
    it 'should see batches awaiting approval' do
      first_admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      second_admin_user = User.create!(
        name: 'Steve Gates', cpf: '35933681024',
        email: 'steve@leilaodogalpao.com.br', password: 'password123'
      )
      Batch.create!(
        code: 'BTC334509', start_date: Date.today, end_date: Date.today + 1,
        min_bid_in_centavos: 15_000, min_diff_between_bids_in_centavos: 10_000,
        creator: first_admin_user
      )
  
      login_as(first_admin_user)
      visit root_path
      click_on 'Listar Lotes'
      
      expect(page).to have_content 'Lotes Aguardando Aprovação'
      expect(page).to have_link 'Lote BTC334509'
    end

    it 'should see a message when there is no batches awaiting approval registered' do
      first_admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )

      login_as(first_admin_user)
      visit root_path
      click_on 'Listar Lotes'
  
      expect(page).to have_content 'Não existem lotes cadastrados/aguardando aprovação.'
    end

    it 'should not see expired batches' do
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
      click_on 'Listar Lotes'
  
      expect(page).not_to have_content 'Lotes Expirados'
      expect(page).not_to have_link 'Lote BTC334509'
    end
  end
end
