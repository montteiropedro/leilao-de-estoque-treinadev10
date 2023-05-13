require 'rails_helper'

describe 'Admin cancels a expired lot' do
  it 'should be sucessful' do
    admin_user = User.create!(
      name: 'John Doe', cpf: '41760209031',
      email: 'john@leilaodogalpao.com.br', password: 'password123'
    )
    Lot.new(
      code: 'COD123456', start_date: Date.today - 1.week, end_date: Date.today - 1.day,
      min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
      creator: admin_user
    ).save!(validate: false)

    login_as(admin_user)
    visit root_path
    click_on 'Listar Lotes Expirados'
    click_on 'Lote COD123456'
    click_on 'Cancelar Lote'
    
    expect(current_path).to eq expired_lots_path
    expect(page).to have_content 'Lote cancelado com sucesso.'
    within('div#lots-expired') do
      expect(page).not_to have_content 'Lote COD123456'
    end
  end
end
