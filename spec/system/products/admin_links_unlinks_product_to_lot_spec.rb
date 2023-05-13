require 'rails_helper'

describe 'Admin links or unlinks a product to/from a lot' do
  context 'when a lot is awaiting approval' do
    context 'and is expired' do
      it 'should not be able to link the product to it' do
        first_admin_user = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )
        Lot.new(
          code: 'COD123456', start_date: Date.today - 1.week, end_date: Date.today - 1.day,
          min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
          creator: first_admin_user
        ).save!(validate: false)
        product = Product.create!(
          name: 'TV 32 Polegadas', description: 'Televisão Samsung de 32 Polegadas.',
          weight: 5_000, width: 100, height: 50, depth: 10
        )
  
        login_as(first_admin_user)
        visit root_path
        click_on 'Listar Produtos'
        click_on 'TV 32 Polegadas'
  
        expect(current_path).to eq product_path(product)
        within('form#link-lot') do
          expect(page).not_to have_content 'Lote COD123456'
        end
      end
  
      it 'should not be able to unlink the product from it' do
        first_admin_user = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )
        Lot.new(
          code: 'COD123456', start_date: Date.today - 1.week, end_date: Date.today - 1.day,
          min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
          creator: first_admin_user
        ).save!(validate: false)
        product = Product.create!(
          name: 'TV 32 Polegadas', description: 'Televisão Samsung de 32 Polegadas.',
          weight: 5_000, width: 100, height: 50, depth: 10,
          lot: Lot.last
        )
  
        login_as(first_admin_user)
        visit root_path
        click_on 'Listar Produtos'
        click_on 'TV 32 Polegadas'
  
        expect(current_path).to eq product_path(product)
        expect(page).not_to have_button 'Remover Vínculo'
      end
    end

    context 'and is not expired' do
      it 'should be able to link the product to it' do
        first_admin_user = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )
        lot = Lot.create!(
          code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
          min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
          creator: first_admin_user
        )
        product = Product.create!(
          name: 'TV 32 Polegadas', description: 'Televisão Samsung de 32 Polegadas.',
          weight: 5_000, width: 100, height: 50, depth: 10,
        )
  
        login_as(first_admin_user)
        visit root_path
        click_on 'Listar Produtos'
        click_on 'TV 32 Polegadas'
        within('form#link-lot') do
          select 'Lote COD123456', from: 'lot_id'
          click_on 'Vincular'
        end
        
        expect(current_path).to eq product_path(product)
        expect(page).to have_content 'Lote vinculado com sucesso.'
        expect(page).not_to have_field 'lot_id'
        expect(page).not_to have_button 'Vincular'
      end
  
      it 'should be able to unlink the product from it' do
        john_admin = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )
        lot = Lot.create!(
          code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
          min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
          creator: john_admin
        )
        product = Product.create!(
          name: 'TV 32 Polegadas', description: 'Televisão Samsung de 32 Polegadas.',
          weight: 5_000, width: 100, height: 50, depth: 10,
          lot: lot
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
  end

  context 'when a lot is approved' do
    context 'and is expired' do
      it 'should not be able to link the product to it' do
        first_admin_user = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )
        second_admin_user = User.create!(
          name: 'Steve Gates', cpf: '35933681024',
          email: 'steve@leilaodogalpao.com.br', password: 'password123'
        )
        Lot.new(
          code: 'COD123456', start_date: Date.today - 1.week, end_date: Date.today - 1.day,
          min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
          creator: first_admin_user, approver: second_admin_user
        ).save!(validate: false)
        product = Product.create!(
          name: 'TV 32 Polegadas', description: 'Televisão Samsung de 32 Polegadas.',
          weight: 5_000, width: 100, height: 50, depth: 10
        )
  
        login_as(first_admin_user)
        visit root_path
        click_on 'Listar Produtos'
        click_on 'TV 32 Polegadas'
  
        expect(current_path).to eq product_path(product)
        within('form#link-lot') do
          expect(page).not_to have_content 'Lote COD123456'
        end
      end
  
      it 'should not be able to unlink the product from it' do
        first_admin_user = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )
        second_admin_user = User.create!(
          name: 'Steve Gates', cpf: '35933681024',
          email: 'steve@leilaodogalpao.com.br', password: 'password123'
        )
        Lot.new(
          code: 'COD123456', start_date: Date.today - 1.week, end_date: Date.today - 1.day,
          min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
          creator: first_admin_user, approver: second_admin_user
        ).save!(validate: false)
        product = Product.create!(
          name: 'TV 32 Polegadas', description: 'Televisão Samsung de 32 Polegadas.',
          weight: 5_000, width: 100, height: 50, depth: 10,
          lot: Lot.last
        )
  
        login_as(first_admin_user)
        visit root_path
        click_on 'Listar Produtos'
        click_on 'TV 32 Polegadas'
  
        expect(current_path).to eq product_path(product)
        expect(page).not_to have_button 'Remover Vínculo'
      end
    end

    context 'and is not expired' do
      it 'should not be able to link the product to it' do
        first_admin_user = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )
        second_admin_user = User.create!(
          name: 'Steve Gates', cpf: '35933681024',
          email: 'steve@leilaodogalpao.com.br', password: 'password123'
        )
        lot = Lot.create!(
          code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
          min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
          creator: first_admin_user, approver: second_admin_user
        )
        product = Product.create!(
          name: 'TV 32 Polegadas', description: 'Televisão Samsung de 32 Polegadas.',
          weight: 5_000, width: 100, height: 50, depth: 10
        )
  
        login_as(first_admin_user)
        visit root_path
        click_on 'Listar Produtos'
        click_on 'TV 32 Polegadas'
  
        expect(current_path).to eq product_path(product)
        within('form#link-lot') do
          expect(page).not_to have_content 'Lote COD123456'
        end
      end
  
      it 'should not be able to unlink the product from it' do
        first_admin_user = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )
        second_admin_user = User.create!(
          name: 'Steve Gates', cpf: '35933681024',
          email: 'steve@leilaodogalpao.com.br', password: 'password123'
        )
        lot = Lot.create!(
          code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
          min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
          creator: first_admin_user, approver: second_admin_user
        )
        product = Product.create!(
          name: 'TV 32 Polegadas', description: 'Televisão Samsung de 32 Polegadas.',
          weight: 5_000, width: 100, height: 50, depth: 10,
          lot: lot
        )
  
        login_as(first_admin_user)
        visit root_path
        click_on 'Listar Produtos'
        click_on 'TV 32 Polegadas'
  
        expect(current_path).to eq product_path(product)
        expect(page).not_to have_button 'Remover Vínculo'
      end
    end
    
  end

  # context 'when a lot is expired' do
  #   it 'should not be able to link the product to it' do
  #     first_admin_user = User.create!(
  #       name: 'John Doe', cpf: '41760209031',
  #       email: 'john@leilaodogalpao.com.br', password: 'password123'
  #     )
  #     second_admin_user = User.create!(
  #       name: 'Steve Gates', cpf: '35933681024',
  #       email: 'steve@leilaodogalpao.com.br', password: 'password123'
  #     )
  #     Lot.new(
  #       code: 'COD123456', start_date: Date.today - 1.week, end_date: Date.today - 1.day,
  #       min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
  #       creator: first_admin_user, approver: second_admin_user
  #     ).save!(validate: false)
  #     product = Product.create!(
  #       name: 'TV 32 Polegadas', description: 'Televisão Samsung de 32 Polegadas.',
  #       weight: 5_000, width: 100, height: 50, depth: 10
  #     )

  #     login_as(first_admin_user)
  #     visit root_path
  #     click_on 'Listar Produtos'
  #     click_on 'TV 32 Polegadas'

  #     expect(current_path).to eq product_path(product)
  #     within('form#link-lot') do
  #       expect(page).not_to have_content 'Lote COD123456'
  #     end
  #   end

  #   it 'should not be able to unlink the product from it' do
  #     first_admin_user = User.create!(
  #       name: 'John Doe', cpf: '41760209031',
  #       email: 'john@leilaodogalpao.com.br', password: 'password123'
  #     )
  #     second_admin_user = User.create!(
  #       name: 'Steve Gates', cpf: '35933681024',
  #       email: 'steve@leilaodogalpao.com.br', password: 'password123'
  #     )
  #     Lot.new(
  #       code: 'COD123456', start_date: Date.today - 1.week, end_date: Date.today - 1.day,
  #       min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
  #       creator: first_admin_user, approver: second_admin_user
  #     ).save!(validate: false)
  #     product = Product.create!(
  #       name: 'TV 32 Polegadas', description: 'Televisão Samsung de 32 Polegadas.',
  #       weight: 5_000, width: 100, height: 50, depth: 10,
  #       lot: Lot.last
  #     )

  #     login_as(first_admin_user)
  #     visit root_path
  #     click_on 'Listar Produtos'
  #     click_on 'TV 32 Polegadas'

  #     expect(current_path).to eq product_path(product)
  #     expect(page).not_to have_button 'Remover Vínculo'
  #   end
  # end

  context 'and the product' do
    it 'should be linked only to one lot' do
      john_admin = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      Lot.create!(
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
      within('form#link-lot') do
        select 'Lote COD123456', from: 'lot_id'
        click_on 'Vincular'
      end

      expect(page).not_to have_field 'lot_id'
      expect(page).not_to have_button 'Vincular'
      expect(page).to have_button 'Remover Vínculo'
    end
  end
end