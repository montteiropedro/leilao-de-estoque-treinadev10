require 'rails_helper'

describe 'User searches a lot by the code or a product linked to it' do
  it 'should be successful' do
    first_admin_user = User.create!(
      name: 'John Doe', cpf: '41760209031',
      email: 'john@leilaodogalpao.com.br', password: 'password123'
    )
    second_admin_user = User.create!(
      name: 'Steve Gates', cpf: '35933681024',
      email: 'steve@leilaodogalpao.com.br', password: 'password123'
    )
    first_lot = Lot.create!(
      code: 'QUA905432', start_date: Date.today, end_date: Date.today + 1.day,
      min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
      creator: first_admin_user, approver: second_admin_user
    )
    second_lot = Lot.create!(
      code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
      min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
      creator: first_admin_user, approver: second_admin_user
    )
    third_lot = Lot.create!(
      code: 'TFT202305', start_date: Date.today, end_date: Date.today + 1.day,
      min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
      creator: first_admin_user, approver: second_admin_user
    )
    Product.create!(
      name: 'Quadro', weight: 1_000,
      width: 30, height: 50, depth: 5,
      lot: second_lot
    )
    Product.create!(
      name: 'Armario', weight: 5_000,
      width: 100, height: 50, depth: 10,
      lot: first_lot
    )

    visit root_path
    click_on 'Listar Lotes'
    fill_in 'Pesquisar lote pelo código ou produto vinculado', with: 'A'
    click_on 'Pesquisar'

    expect(page).to have_content 'Lote QUA905432', count: 1
    expect(page).to have_content 'Lote COD123456', count: 1
    expect(page).not_to have_content 'Lote TFT202305', count: 1
  end
end
