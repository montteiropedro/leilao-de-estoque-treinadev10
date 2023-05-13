require 'rails_helper'

describe 'User visits a product details page' do
  it 'from user menu' do
    admin_user = User.create!(
      name: 'John Doe', cpf: '41760209031',
      email: 'john@leilaodogalpao.com.br', password: 'password123'
    )

    login_as(admin_user)
    visit root_path
    within('#product-menu') do
      click_on 'Listar Produtos'
    end

    expect(current_path).to eq products_path
    expect(page).to have_content 'Produtos'
  end

  it 'should be successful' do
    product = Product.create!(
      name: 'TV 32 Polegadas', description: 'Televisão Samsung de 32 Polegadas.',
      weight: 5_000, width: 100, height: 50, depth: 10
    )

    visit root_path
    click_on 'Listar Produtos'
    click_on 'TV 32 Polegadas'

    expect(page).to have_content 'TV 32 Polegadas'
    expect(page).to have_content 'Televisão Samsung de 32 Polegadas.'
    expect(page).to have_content 'Categoria: Não especificado'
    expect(page).to have_content 'Peso: 5000g'
    expect(page).to have_content 'Largura: 100cm'
    expect(page).to have_content 'Altura: 50cm'
    expect(page).to have_content 'Profundidade: 10cm'
    expect(page).to have_content 'Lote: Não vinculado a um lote'
  end

  context 'and is a visitant' do
    it 'should not see the button to remove the product' do
      product = Product.create!(
        name: 'TV 32 Polegadas', description: 'Televisão Samsung de 32 Polegadas.',
        weight: 5_000, width: 100, height: 50, depth: 10
      )
  
      visit root_path
      click_on 'Listar Produtos'
      click_on 'TV 32 Polegadas'
  
      expect(page).not_to have_button 'Remover Produto'
    end

    it 'should not see the button to link the product to a batch' do
      product = Product.create!(
        name: 'TV 32 Polegadas', description: 'Televisão Samsung de 32 Polegadas.',
        weight: 5_000, width: 100, height: 50, depth: 10
      )
  
      visit root_path
      click_on 'Listar Produtos'
      click_on 'TV 32 Polegadas'
  
      expect(page).not_to have_field 'batch_id'
      expect(page).not_to have_button 'Vincular'
    end

    it 'should not see the button to unlink the product from a batch' do
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
  
      visit root_path
      click_on 'Listar Produtos'
      click_on 'TV 32 Polegadas'
  
      expect(page).not_to have_button 'Remover Vínculo'
    end

    context 'and the product is connected to a batch' do
      it 'should show a link to it if approved' do
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
    
        visit root_path
        click_on 'Listar Produtos'
        click_on 'TV 32 Polegadas'
    
        expect(page).to have_content 'Lote: COD123456'
        expect(page).to have_link 'COD123456'
      end

      it 'should not show a link to it if awaiting approval' do
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
    
        visit root_path
        click_on 'Listar Produtos'
        click_on 'TV 32 Polegadas'
    
        expect(page).to have_content 'Lote: COD123456 <Aguardando aprovação>'
        expect(page).not_to have_link 'COD123456'
      end
    end
  end

  context 'and is not a admin' do
    it 'should not see the button to remove the product' do
      user = User.create!(
        name: 'Peter Parker', cpf: '73046259026',
        email: 'peter@email.com', password: 'password123'
      )
      product = Product.create!(
        name: 'TV 32 Polegadas', description: 'Televisão Samsung de 32 Polegadas.',
        weight: 5_000, width: 100, height: 50, depth: 10
      )
  
      login_as(user)
      visit root_path
      click_on 'Listar Produtos'
      click_on 'TV 32 Polegadas'
  
      expect(page).not_to have_button 'Remover Produto'
    end

    it 'should not see the button to link the product to a batch' do
      user = User.create!(
        name: 'Peter Parker', cpf: '73046259026',
        email: 'peter@email.com', password: 'password123'
      )
      product = Product.create!(
        name: 'TV 32 Polegadas', description: 'Televisão Samsung de 32 Polegadas.',
        weight: 5_000, width: 100, height: 50, depth: 10
      )
  
      login_as(user)
      visit root_path
      click_on 'Listar Produtos'
      click_on 'TV 32 Polegadas'
  
      expect(page).not_to have_field 'batch_id'
      expect(page).not_to have_button 'Vincular'
    end

    it 'should not see the button to unlink the product from a batch' do
      user = User.create!(
        name: 'Peter Parker', cpf: '73046259026',
        email: 'peter@email.com', password: 'password123'
      )
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
  
      login_as(user)
      visit root_path
      click_on 'Listar Produtos'
      click_on 'TV 32 Polegadas'
  
      expect(page).not_to have_button 'Remover Vínculo'
    end

    context 'and the product is connected to a batch' do
      it 'should show a link to it if approved' do
        peter = User.create!(
          name: 'Peter Parker', cpf: '73046259026',
          email: 'peter@email.com', password: 'password123'
        )
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
    
        login_as(peter)
        visit root_path
        click_on 'Listar Produtos'
        click_on 'TV 32 Polegadas'
    
        expect(page).to have_content 'Lote: COD123456'
        expect(page).to have_link 'COD123456'
      end

      it 'should not show a link to it if awaiting approval' do
        peter = User.create!(
          name: 'Peter Parker', cpf: '73046259026',
          email: 'peter@email.com', password: 'password123'
        )
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
    
        login_as(peter)
        visit root_path
        click_on 'Listar Produtos'
        click_on 'TV 32 Polegadas'
    
        expect(page).to have_content 'Lote: COD123456 <Aguardando aprovação>'
        expect(page).not_to have_link 'COD123456'
      end
    end
  end

  context 'and is a admin' do
    context 'the button to delete the product' do
      it 'should be displayed when the product is not linked with a batch' do
        admin_user = User.create!(
          name: 'John Doe', cpf: '41760209031',
          email: 'john@leilaodogalpao.com.br', password: 'password123'
        )
        product = Product.create!(
          name: 'TV 32 Polegadas', description: 'Televisão Samsung de 32 Polegadas.',
          weight: 5_000, width: 100, height: 50, depth: 10
        )
    
        login_as(admin_user)
        visit root_path
        click_on 'Listar Produtos'
        click_on 'TV 32 Polegadas'
    
        expect(page).to have_button 'Deletar Produto'
      end

      context 'when the linked batch is awaiting approval' do
        it 'and is not expired should be displayed' do
          admin_user = User.create!(
            name: 'John Doe', cpf: '41760209031',
            email: 'john@leilaodogalpao.com.br', password: 'password123'
          )
          batch = Batch.create!(
            code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
            min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
            creator: admin_user
          )
          Product.create!(
            name: 'TV 32 Polegadas', description: 'Televisão Samsung de 32 Polegadas.',
            weight: 5_000, width: 100, height: 50, depth: 10,
            batch: batch
          )
      
          login_as(admin_user)
          visit root_path
          click_on 'Listar Produtos'
          click_on 'TV 32 Polegadas'
      
          expect(page).to have_button 'Deletar Produto'
        end

        it 'and is expired should not be displayed' do
          admin_user = User.create!(
            name: 'John Doe', cpf: '41760209031',
            email: 'john@leilaodogalpao.com.br', password: 'password123'
          )
          Batch.new(
            code: 'COD123456', start_date: Date.today - 1.week, end_date: Date.today - 1.day,
            min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
            creator: admin_user
          ).save!(validate: false)
          Product.create!(
            name: 'TV 32 Polegadas', description: 'Televisão Samsung de 32 Polegadas.',
            weight: 5_000, width: 100, height: 50, depth: 10,
            batch: Batch.last
          )
      
          login_as(admin_user)
          visit root_path
          click_on 'Listar Produtos'
          click_on 'TV 32 Polegadas'
      
          expect(page).not_to have_button 'Deletar Produto'
        end
      end

      context 'when the linked batch is approved' do
        it 'and is not expired should not be displayed' do
          first_admin_user = User.create!(
            name: 'John Doe', cpf: '41760209031',
            email: 'john@leilaodogalpao.com.br', password: 'password123'
          )
          second_admin_user = User.create!(
            name: 'Steve Gates', cpf: '35933681024',
            email: 'steve@leilaodogalpao.com.br', password: 'password123'
          )
          batch = Batch.create!(
            code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
            min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
            creator: first_admin_user, approver: second_admin_user
          )
          Product.create!(
            name: 'TV 32 Polegadas', description: 'Televisão Samsung de 32 Polegadas.',
            weight: 5_000, width: 100, height: 50, depth: 10,
            batch: batch
          )
      
          login_as(first_admin_user)
          visit root_path
          click_on 'Listar Produtos'
          click_on 'TV 32 Polegadas'
      
          expect(page).not_to have_button 'Deletar Produto'
        end

        it 'and is expired should not be displayed' do
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
          Product.create!(
            name: 'TV 32 Polegadas', description: 'Televisão Samsung de 32 Polegadas.',
            weight: 5_000, width: 100, height: 50, depth: 10,
            batch: Batch.last
          )
      
          login_as(first_admin_user)
          visit root_path
          click_on 'Listar Produtos'
          click_on 'TV 32 Polegadas'
      
          expect(page).not_to have_button 'Deletar Produto'
        end
      end
    end

    it 'should see the form to link the product to a batch' do
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
  
      expect(page).to have_field 'batch_id'
      expect(page).to have_button 'Vincular'
    end

    it 'should see the button to unlink the product from a batch' do
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
  
      expect(page).to have_button 'Remover Vínculo'
    end

    context 'and the product is connected to a batch' do
      it 'should show a link to it if approved' do
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
    
        expect(page).to have_content 'Lote: COD123456'
        expect(page).to have_link 'COD123456'
      end

      it 'should show a link to it if awaiting approval' do
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
    
        expect(page).to have_content 'Lote: COD123456 <Aguardando aprovação>'
        expect(page).to have_link 'COD123456'
      end
    end
  end
end
