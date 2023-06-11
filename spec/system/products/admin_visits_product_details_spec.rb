require 'rails_helper'

describe 'Administrador visita a página de detalhes de um produto' do
  it 'partindo do menu de produtos' do
    admin_user = User.create!(
      name: 'John Doe', cpf: '41760209031',
      email: 'john@leilaodogalpao.com.br', password: 'password123'
    )

    product = Product.create!(
      name: 'TV 32 Polegadas', description: 'Televisão Samsung de 32 Polegadas.',
      weight: 5_000, width: 100, height: 50, depth: 10
    )

    login_as admin_user
    visit root_path
    within '#product-menu' do
      click_on 'Listar Produtos'
    end
    click_on 'TV 32 Polegadas'

    expect(current_path).to eq product_path(product)
    expect(page).to have_content 'TV 32 Polegadas'
    expect(page).to have_content 'Televisão Samsung de 32 Polegadas.'
    expect(page).to have_content 'Categoria: Não especificado'
    expect(page).to have_content 'Peso: 5000g'
    expect(page).to have_content 'Largura: 100cm'
    expect(page).to have_content 'Altura: 50cm'
    expect(page).to have_content 'Profundidade: 10cm'
    expect(page).to have_content 'Lote: Não vinculado a um lote'
  end

  context 'e caso o produto não esteja vinculado a um lote' do
    it 'o formulário para vincular a um lote deve ser exibido' do
      admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      product = Product.create!(
        name: 'TV 32 Polegadas', description: 'Televisão Samsung de 32 Polegadas.',
        weight: 5_000, width: 100, height: 50, depth: 10
      )

      login_as admin_user
      visit product_path(product)

      expect(page).to have_field 'lot_id'
      expect(page).to have_button 'Vincular'
    end
  end

  context 'e caso o produto esteja vinculado a um lote' do
    context 'e o lote está aguardando aprovação' do
      it 'o botão de remover o vinculo deve ser exibido' do
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
        visit product_path(product)

        expect(page).to have_button 'Remover Vínculo'
      end

      it 'um link para a página de detalhes do mesmo deve ser exibido' do
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
        visit product_path(product)

        expect(page).to have_content 'Lote: COD123456 <Aguardando aprovação>'
        expect(page).to have_link 'COD123456'
      end
    end

    context 'e o lote está aprovado' do
      it 'o botão de remover o vinculo não deve ser exibido' do
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
        visit product_path(product)

        expect(page).not_to have_button 'Remover Vínculo'
      end

      it 'um link para a página de detalhes do mesmo deve ser exibido' do
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
        visit product_path(product)

        expect(page).to have_content 'Lote: COD123456'
        expect(page).to have_link 'COD123456'
      end
    end
  end
end
