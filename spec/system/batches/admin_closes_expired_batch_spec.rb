require 'rails_helper'

describe 'Admin closes a expired batch' do
  it 'should be sucessful' do
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
    Batch.new(
      code: 'COD123456', start_date: Date.today - 1.week, end_date: Date.today - 1.day,
      min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
      creator: first_admin_user, approver: second_admin_user
    ).save!(validate: false)
    Bid.new(value_in_centavos: 10_500, user: user, batch: Batch.last).save!(validate: false)

    login_as(first_admin_user)
    visit root_path
    click_on 'Listar Lotes Expirados'
    click_on 'Lote COD123456'
    click_on 'Encerrar Lote'
    
    expect(current_path).to eq expired_batches_path
    expect(page).to have_content 'Lote encerrado com sucesso.'
    within('div#batches-expired') do
      expect(page).not_to have_content 'Lote COD123456'
    end
    within('div#batches-expired-closed') do
      expect(page).to have_content 'Lote COD123456'
    end
  end
end
