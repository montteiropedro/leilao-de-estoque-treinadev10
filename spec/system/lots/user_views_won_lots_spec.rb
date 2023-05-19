require 'rails_helper'

describe 'User views lots where he is the winner' do
  it 'from menu' do
    user = User.create!(
      name: 'Peter Parker', cpf: '73046259026',
      email: 'peter@email.com', password: 'password123'
    )

    login_as user
    visit root_path
    within('div#lot-menu') do
      click_on 'Listar Lotes Vencidos'
    end

    expect(current_path).to eq won_lots_path
  end

  it 'and should be successful' do
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
      code: 'BTC334509', start_date: Date.today, end_date: 3.days.from_now,
      min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
      creator: first_admin_user, approver: second_admin_user, buyer: user
    )

    travel_to 1.week.from_now do
      login_as user
      visit root_path
      click_on 'Listar Lotes Vencidos'
    end

    expect(page).to have_content 'Lotes Vencidos'
    within('section#lots-won') do
      expect(page).to have_link 'Lote BTC334509'
    end
  end

  it 'and should see a message when there is no won lots' do
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

    login_as user
    visit root_path
    click_on 'Listar Lotes Vencidos'

    expect(page).to have_content 'Não existem lotes nos quais você foi o vencedor.'
  end

  context 'admin user' do
    it 'should not be able to visit won lots listing page' do
      admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
  
      login_as admin_user
      visit won_lots_path
  
      expect(current_path).not_to eq won_lots_path
      expect(current_path).to eq root_path
    end
  end

  context 'visitant' do
    it 'should not be able to visit won lots listing page' do
      visit won_lots_path
  
      expect(current_path).not_to eq won_lots_path
      expect(current_path).to eq new_user_session_path
    end
  end
end
