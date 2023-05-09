require 'rails_helper'

describe 'Admin links or unlinks a product to/from a batch' do
  context 'when a batch is approved' do
    it 'should not be able to link the product to it' do
      john_admin = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      steve_admin = User.create!(
        name: 'Steve Gates', cpf: '35933681024',
        email: 'steve@leilaodogalpao.com.br', password: 'password123'
      )
      batch = Batch.create!(
        code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: john_admin, approver: steve_admin
      )
      product = Product.create!(
        name: 'TV 32 Polegadas', description: 'Televisão Samsung de 32 Polegadas.',
        weight: 5_000, width: 100, height: 50, depth: 10
      )

      login_as(john_admin)
      visit root_path
      click_on 'Listar Produtos'
      click_on 'TV 32 Polegadas'

      expect(current_path).to eq product_path(product)
      within('form#link-batch') do
        expect(page).not_to have_content 'Lote COD123456'
      end
    end

    it 'should not be able to unlink the product from it' do
      john_admin = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      steve_admin = User.create!(
        name: 'Steve Gates', cpf: '35933681024',
        email: 'steve@leilaodogalpao.com.br', password: 'password123'
      )
      batch = Batch.create!(
        code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: john_admin, approver: steve_admin
      )
      product = Product.create!(
        name: 'TV 32 Polegadas', description: 'Televisão Samsung de 32 Polegadas.',
        weight: 5_000, width: 100, height: 50, depth: 10,
        batch: batch
      )

      login_as(john_admin)
      visit root_path
      click_on 'Listar Produtos'
      click_on 'TV 32 Polegadas'

      expect(current_path).to eq product_path(product)
      expect(page).not_to have_button 'Remover Vínculo'
    end
  end

  context 'when batch awaiting approval' do
    it 'should be able to link the product to it' do
      john_admin = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      batch = Batch.create!(
        code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: john_admin
      )
      product = Product.create!(
        name: 'TV 32 Polegadas', description: 'Televisão Samsung de 32 Polegadas.',
        weight: 5_000, width: 100, height: 50, depth: 10,
      )

      login_as(john_admin)
      visit root_path
      click_on 'Listar Produtos'
      click_on 'TV 32 Polegadas'
      within('form#link-batch') do
        select 'Lote COD123456', from: 'batch_id'
        click_on 'Vincular'
      end
      
      expect(current_path).to eq product_path(product)
      expect(page).to have_content 'Lote vinculado com sucesso.'
      expect(page).not_to have_field 'batch_id'
      expect(page).not_to have_button 'Vincular'
    end

    it 'should be able to unlink the product from it' do
      john_admin = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      batch = Batch.create!(
        code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: john_admin
      )
      product = Product.create!(
        name: 'TV 32 Polegadas', description: 'Televisão Samsung de 32 Polegadas.',
        weight: 5_000, width: 100, height: 50, depth: 10,
        batch: batch
      )

      login_as(john_admin)
      visit root_path
      click_on 'Listar Produtos'
      click_on 'TV 32 Polegadas'
      click_on 'Remover Vínculo'

      expect(current_path).to eq product_path(product)
      expect(page).to have_content 'Lote desvinculado com sucesso.'
      expect(page).not_to have_button 'Remover Vínculo'
    end
  end

  context 'and the product' do
    it 'should be linked only to one batch' do
      john_admin = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      Batch.create!(
        code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: john_admin
      )
      product = Product.create!(
        name: 'TV 32 Polegadas', description: 'Televisão Samsung de 32 Polegadas.',
        weight: 5_000, width: 100, height: 50, depth: 10,
      )

      login_as(john_admin)
      visit root_path
      click_on 'Listar Produtos'
      click_on 'TV 32 Polegadas'
      within('form#link-batch') do
        select 'Lote COD123456', from: 'batch_id'
        click_on 'Vincular'
      end

      expect(page).not_to have_field 'batch_id'
      expect(page).not_to have_button 'Vincular'
      expect(page).to have_button 'Remover Vínculo'
    end
  end
end
