require 'rails_helper'

describe 'User visits a lot details page' do
  it 'from menu' do
    admin_user = User.create!(
      name: 'John Doe', cpf: '41760209031',
      email: 'john@leilaodogalpao.com.br', password: 'password123'
    )
    lot = Lot.create!(
      code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
      min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
      creator: admin_user
    )

    login_as admin_user
    visit root_path
    within('#lot-menu') do
      click_on 'Listar Lotes'
    end
    click_on 'Lote COD123456'

    expect(current_path).to eq lot_path(lot)
  end

  it 'should be successful' do
    admin_user = User.create!(
      name: 'John Doe', cpf: '41760209031',
      email: 'john@leilaodogalpao.com.br', password: 'password123'
    )
    lot = Lot.create!(
      code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
      min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
      creator: admin_user
    )

    login_as admin_user
    visit root_path
    click_on 'Listar Lotes'
    click_on 'Lote COD123456'

    expect(page).to have_content 'Lote COD123456'
    expect(page).to have_content 'Administrado por John Doe <john@leilaodogalpao.com.br>'
    expect(page).to have_content "Data de Início: #{lot.start_date.strftime('%d/%m/%Y')}"
    expect(page).to have_content "Data do Fim: #{lot.end_date.strftime('%d/%m/%Y')}"
    expect(page).to have_content 'Lance Mínimo: R$ 100,00'
    expect(page).to have_content 'Diferença Mínima Entre Lances: R$ 50,00'
  end

  it 'should show products linked to it' do
    admin_user = User.create!(
      name: 'John Doe', cpf: '41760209031',
      email: 'john@leilaodogalpao.com.br', password: 'password123'
    )
    lot = Lot.create!(
      code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
      min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
      creator: admin_user
    )
    product = Product.create!(
      name: 'Quadro', weight: 1_000,
      width: 30, height: 50, depth: 5,
      lot: lot
    )

    login_as admin_user
    visit root_path
    click_on 'Listar Lotes'
    click_on 'Lote COD123456'

    expect(page).to have_content 'Quadro'
  end

  it 'should show a message when there is no products linked to it' do
    admin_user = User.create!(
      name: 'John Doe', cpf: '41760209031',
      email: 'john@leilaodogalpao.com.br', password: 'password123'
    )
    lot = Lot.create!(
      code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
      min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
      creator: admin_user
    )

    login_as admin_user
    visit root_path
    click_on 'Listar Lotes'
    click_on 'Lote COD123456'

    expect(page).to have_content 'Não existem produtos vinculados a este lote.'
  end
end
