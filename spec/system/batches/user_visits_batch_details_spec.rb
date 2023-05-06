require 'rails_helper'

describe 'User visits a batch details page' do
  it 'from user menu' do
    admin_user = User.create!(
      name: 'John Doe', cpf: '41760209031',
      email: 'john@leilaodogalpao.com.br', password: 'password123'
    )
    batch = Batch.create!(
      code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
      min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
      creator: admin_user
    )

    visit root_path
    within('#batch-menu') do
      click_on 'Lotes em Leilão'
    end
    click_on "Lote COD123456"

    expect(current_path).to eq batch_path(batch)
  end

  it 'should be successful' do
    admin_user = User.create!(
      name: 'John Doe', cpf: '41760209031',
      email: 'john@leilaodogalpao.com.br', password: 'password123'
    )
    batch = Batch.create!(
      code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
      min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
      creator: admin_user
    )

    visit root_path
    click_on 'Lotes em Leilão'
    click_on "Lote COD123456"

    expect(page).to have_content "Lote COD123456"
    expect(page).to have_content 'Administrado por John Doe <john@leilaodogalpao.com.br>'
    expect(page).to have_content "Data de Início: #{batch.start_date.strftime('%d/%m/%Y')}"
    expect(page).to have_content "Data do Fim: #{batch.end_date.strftime('%d/%m/%Y')}"
    expect(page).to have_content 'Lance Mínimo: 10000 centavos'
    expect(page).to have_content 'Diferença Mínima Entre Lances: 5000 centavos'
  end

  context 'and is a visitant' do
    it 'should not see the button to approve the batch' do
      admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      batch = Batch.create!(
        code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: admin_user
      )

      visit root_path
      click_on 'Lotes em Leilão'
      click_on "Lote COD123456"
  
      expect(page).not_to have_button 'Aprovar Lote'
    end
  end

  context 'and is not a admin' do
    it 'should not see the button to approve the batch' do
      user = User.create!(
        name: 'Peter Parker', cpf: '73046259026',
        email: 'peter@email.com', password: 'password123'
      )
      admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      batch = Batch.create!(
        code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: admin_user
      )

      login_as(user)
      visit root_path
      click_on 'Lotes em Leilão'
      click_on "Lote COD123456"
  
      expect(page).not_to have_button 'Aprovar Lote'
    end
  end

  context 'and is a admin' do
    it 'should see the button to approve the batch if it was not created by him' do
      first_admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      second_admin_user = User.create!(
        name: 'Steve Gates', cpf: '35933681024',
        email: 'steve@leilaodogalpao.com.br', password: 'password123'
      )
      batch = Batch.create!(
        code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: second_admin_user
      )

      login_as(first_admin_user)
      visit root_path
      click_on 'Aprovar Lotes'
      click_on "Lote COD123456"
  
      expect(page).to have_button 'Aprovar Lote'
    end

    it 'should not see the button to approve the batch if it was created by him' do
      first_admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      second_admin_user = User.create!(
        name: 'Steve Gates', cpf: '35933681024',
        email: 'steve@leilaodogalpao.com.br', password: 'password123'
      )
      batch = Batch.create!(
        code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: second_admin_user
      )

      login_as(second_admin_user)
      visit root_path
      click_on 'Aprovar Lotes'
      click_on "Lote COD123456"
  
      expect(page).not_to have_button 'Aprovar Lote'
    end
  end
end
