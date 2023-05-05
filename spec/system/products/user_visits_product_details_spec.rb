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
  
      expect(page).not_to have_button 'Vincular Produto a um Lote'
    end

    it 'should not see the button to unlink the product from a batch' do
      admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      batch = Batch.create!(
        code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
        minimum_bid: 10_000, minimum_difference_between_bids: 5_000,
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
  
      expect(page).not_to have_button 'Vincular Produto a um Lote'
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
        minimum_bid: 10_000, minimum_difference_between_bids: 5_000,
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
  end

  context 'and is a admin' do
    it 'should see the button to remove the product' do
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
  
      expect(page).to have_button 'Remover Produto'
    end

    it 'should see the button to link the product to a batch' do
      admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      batch = Batch.create!(
        code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
        minimum_bid: 10_000, minimum_difference_between_bids: 5_000,
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
  
      expect(page).to have_button 'Vincular Produto a um Lote'
    end

    it 'should see the button to unlink the product from a batch' do
      admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      batch = Batch.create!(
        code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
        minimum_bid: 10_000, minimum_difference_between_bids: 5_000,
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
  end
end
