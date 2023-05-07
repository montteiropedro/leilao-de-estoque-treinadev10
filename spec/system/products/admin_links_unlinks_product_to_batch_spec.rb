require 'rails_helper'

describe 'Admin links or unlinks a product to/from a batch' do
  context 'when product has no batch linked' do
    it 'should be successful linking to one' do
      admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      batch = Batch.create!(
        code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: admin_user
      )
      product = Product.create!(
        name: 'TV 32 Polegadas', description: 'Televisão Samsung de 32 Polegadas.',
        weight: 5_000, width: 100, height: 50, depth: 10
      )

      login_as(admin_user)
      visit root_path
      click_on 'Listar Produtos'
      click_on 'TV 32 Polegadas'

      within('form#link-batch') do
        select 'Lote COD123456', from: 'batch_id'
        click_on 'Vincular'
      end

      expect(current_path).to eq product_path(product)
      expect(page).to have_content 'Lote: COD123456'
      expect(page).to have_link 'COD123456'
    end
  end

  context 'when product has a batch linked' do
    it 'should be successful unlinking from it' do
      admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      batch = Batch.create!(
        code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: admin_user
      )
      product = Product.create!(
        name: 'TV 32 Polegadas', description: 'Televisão Samsung de 32 Polegadas.',
        weight: 5_000, width: 100, height: 50, depth: 10,
        batch: batch
      )

      login_as(admin_user)
      visit root_path
      click_on 'Listar Produtos'
      click_on 'TV 32 Polegadas'
      click_on 'Remover Vínculo'

      expect(current_path).to eq product_path(product)
      expect(page).to have_content 'Lote desvinculado com sucesso.'
      expect(page).to have_field 'batch_id'
      expect(page).to have_button 'Vincular'
      expect(page).not_to have_content 'Lote: COD123456'
      expect(page).not_to have_link 'COD123456'
    end
  end
end
