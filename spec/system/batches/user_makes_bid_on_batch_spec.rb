require 'rails_helper'

describe 'User makes a bid on a batch' do
  context 'when is not a admin' do
    it 'should be able to make a bid with a valid value' do
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
      batch = Batch.create!(
        code: 'COD123456', start_date: Date.today, end_date: Date.today + 1,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: first_admin_user, approver: second_admin_user
      )

      login_as(user)
      visit root_path
      click_on 'Listar Lotes'
      within('div#batches-in-progress') do
        click_on 'COD123456'
      end
      fill_in 'Faça seu lance', with: 10_001
      click_on 'Fazer Lance'

      expect(current_path).to eq batch_path(batch)
      expect(page).to have_content 'Lance realizado com sucesso.'
      expect(page).to have_content 'Último lance: 10001 centavos'
    end

    context 'and batch has no bid yet' do
      it 'should not be able to make a bid with a invalid value' do
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
        batch = Batch.create!(
          code: 'COD123456', start_date: Date.today, end_date: Date.today + 1,
          min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
          creator: first_admin_user, approver: second_admin_user
        )
  
        login_as(user)
        visit root_path
        click_on 'Listar Lotes'
        within('div#batches-in-progress') do
          click_on 'COD123456'
        end
        fill_in 'Faça seu lance', with: 100
        click_on 'Fazer Lance'
  
        expect(current_path).to eq batch_path(batch)
        expect(page).to have_content 'Lance deve ser maior ou igual a 10001'
        expect(page).to have_content 'Último lance: 0 centavos'
      end
    end
    
    context 'and batch already has a bid' do
      it 'should not be able to make a bid with a invalid value' do
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
        batch = Batch.create!(
          code: 'COD123456', start_date: Date.today, end_date: Date.today + 1,
          min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
          creator: first_admin_user, approver: second_admin_user
        )
        Bid.create!(user: user, batch: batch, value_in_centavos: 20_000)
  
        login_as(user)
        visit root_path
        click_on 'Listar Lotes'
        within('div#batches-in-progress') do
          click_on 'COD123456'
        end
        fill_in 'Faça seu lance', with: 100
        click_on 'Fazer Lance'
  
        expect(current_path).to eq batch_path(batch)
        expect(page).to have_content 'Lance deve ser maior ou igual a 25000'
        expect(page).to have_content 'Último lance: 20000 centavos'
      end
    end
  end
end
