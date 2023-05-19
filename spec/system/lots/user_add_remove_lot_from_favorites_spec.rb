require 'rails_helper'

describe 'User tries to add/remove a lot to/from favorites' do
  context 'when is a not a admin' do
    it 'should be able to add the lot to his favorites' do
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

      login_as user
      visit root_path
      click_on 'Listar Lotes'
      click_on 'Lote COD123456'
      click_on 'add-to-favorite'

      expect(page).to have_content 'Lote adicionado aos favoritos.'
      expect(user.favorite_lots.exists?(lot.id)).to eq true
    end

    it 'should be able to remove the lot from his favorites' do
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

      login_as user
      visit root_path
      click_on 'Listar Lotes'
      click_on 'Lote COD123456'
      click_on 'remove-from-favorite'

      expect(page).to have_content 'Lote removido dos favoritos.'
      expect(user.favorite_lots.exists?(lot.id)).to eq false
    end
  end

  context 'when is a admin' do
    it 'should be able to add the lot to his favorites' do
      admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      lot = Lot.create!(
        code: 'COD123456', start_date: Date.today, end_date: 3.days.from_now,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: admin_user
      )

      login_as admin_user
      visit root_path
      click_on 'Listar Lotes'
      click_on 'Lote COD123456'
      click_on 'add-to-favorite'

      expect(page).to have_content 'Lote adicionado aos favoritos.'
      expect(admin_user.favorite_lots.exists?(lot.id)).to eq true
    end

    it 'should be able to remove the lot from his favorites' do
      admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      lot = Lot.create!(
        code: 'COD123456', start_date: Date.today, end_date: 3.days.from_now,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: admin_user
      )
      admin_user.favorite_lots << lot

      login_as admin_user
      visit root_path
      click_on 'Listar Lotes'
      click_on 'Lote COD123456'
      click_on 'remove-from-favorite'

      expect(page).to have_content 'Lote removido dos favoritos.'
      expect(admin_user.favorite_lots.exists?(lot.id)).to eq false
    end
  end
end
