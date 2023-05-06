require 'rails_helper'

describe 'User views all registered batches' do
  it 'from menu' do
    visit root_path
    within('#batch-menu') do
      click_on 'Listar Lotes'
    end

    expect(current_path).to eq batches_path
    expect(page).to have_content('Lotes')
  end

  it 'should be successful' do
    admin_user = User.create!(
      name: 'John Doe', cpf: '41760209031',
      email: 'john@leilaodogalpao.com.br', password: 'password123'
    )
    Batch.create!(
      code: 'COD123456', start_date: Date.today, end_date: Date.today + 1,
      min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
      creator: admin_user
    )
    Batch.create!(
      code: 'BTC334509', start_date: Date.today, end_date: Date.today + 1,
      min_bid_in_centavos: 15_000, min_diff_between_bids_in_centavos: 10_000,
      creator: admin_user
    )

    visit root_path
    click_on 'Listar Lotes'

    expect(page).to have_link 'Lote COD123456'
    expect(page).to have_link 'Lote BTC334509'
  end

  it 'and should see a message when there is no batches registered' do
    visit root_path
    click_on 'Listar Lotes'

    expect(page).to have_content 'Não existem lotes cadastrados.'
  end
end
