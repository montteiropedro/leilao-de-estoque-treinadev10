require 'rails_helper'

describe 'Administrador tenta desvincular um produto de um lote' do
  context 'expirado' do
    context 'que não recebeu uma aprovação' do
      it 'e não deve ser bem sucedido' do
        admin_user = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )
        lot = Lot.create!(
          code: 'COD123456', start_date: Date.current, end_date: 3.days.from_now,
          min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
          creator: admin_user
        )
        product = Product.create!(
          name: 'TV 32 Polegadas', description: 'Televisão Samsung de 32 Polegadas.',
          weight: 5_000, width: 100, height: 50, depth: 10, lot:
        )

        travel_to 1.week.from_now do
          login_as admin_user
          visit root_path
          click_on 'Listar Produtos'
          click_on 'TV 32 Polegadas'
        end

        expect(current_path).to eq product_path(product)
        expect(page).not_to have_button 'Remover Vínculo'
      end
    end

    context 'que recebeu uma aprovação' do
      it 'e não deve ser bem sucedido' do
        admin_user_a = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )
        admin_user_b = User.create!(
          name: 'Steve Gates', cpf: '35933681024',
          email: 'steve@leilaodogalpao.com.br', password: 'password123'
        )
        lot = Lot.create!(
          code: 'COD123456', start_date: Date.current, end_date: 3.days.from_now,
          min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
          creator: admin_user_a, approver: admin_user_b
        )
        product = Product.create!(
          name: 'TV 32 Polegadas', description: 'Televisão Samsung de 32 Polegadas.',
          weight: 5_000, width: 100, height: 50, depth: 10, lot:
        )

        travel_to 1.week.from_now do
          login_as admin_user_a
          visit root_path
          click_on 'Listar Produtos'
          click_on 'TV 32 Polegadas'
        end

        expect(current_path).to eq product_path(product)
        expect(page).not_to have_button 'Remover Vínculo'
      end
    end
  end

  context 'não expirado' do
    context 'que está aguardando aprovação' do
      it 'e deve ser bem sucedido' do
        admin_user = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )
        lot = Lot.create!(
          code: 'COD123456', start_date: Date.current, end_date: 1.week.from_now,
          min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
          creator: admin_user
        )
        product = Product.create!(
          name: 'TV 32 Polegadas', description: 'Televisão Samsung de 32 Polegadas.',
          weight: 5_000, width: 100, height: 50, depth: 10, lot:
        )

        login_as admin_user
        visit root_path
        click_on 'Listar Produtos'
        click_on 'TV 32 Polegadas'
        click_on 'Remover Vínculo'

        expect(current_path).to eq product_path(product)
        expect(page).to have_content 'Lote desvinculado com sucesso.'
        expect(page).to have_field 'lot_id'
        expect(page).to have_button 'Vincular'
        expect(product.reload).to be_available
        expect(page).not_to have_button 'Remover Vínculo'
      end
    end

    context 'que está aprovado' do
      it 'e não deve ser bem sucedido' do
        admin_user_a = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )
        admin_user_b = User.create!(
          name: 'Steve Gates', cpf: '35933681024',
          email: 'steve@leilaodogalpao.com.br', password: 'password123'
        )
        lot = Lot.create!(
          code: 'COD123456', start_date: Date.current, end_date: 1.week.from_now,
          min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
          creator: admin_user_a, approver: admin_user_b
        )
        product = Product.create!(
          name: 'TV 32 Polegadas', description: 'Televisão Samsung de 32 Polegadas.',
          weight: 5_000, width: 100, height: 50, depth: 10, lot:
        )

        login_as admin_user_a
        visit root_path
        click_on 'Listar Produtos'
        click_on 'TV 32 Polegadas'

        expect(current_path).to eq product_path(product)
        expect(page).not_to have_button 'Remover Vínculo'
      end
    end
  end
end
