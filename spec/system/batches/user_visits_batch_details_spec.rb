require 'rails_helper'

describe 'User visits a batch details page' do
  it 'from menu' do
    admin_user = User.create!(
      name: 'John Doe', cpf: '41760209031',
      email: 'john@leilaodogalpao.com.br', password: 'password123'
    )
    batch = Batch.create!(
      code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
      min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
      creator: admin_user
    )

    login_as(admin_user)
    visit root_path
    within('#batch-menu') do
      click_on 'Listar Lotes'
    end
    click_on 'Lote COD123456'

    expect(current_path).to eq batch_path(batch)
  end

  it 'should be successful' do
    admin_user = User.create!(
      name: 'John Doe', cpf: '41760209031',
      email: 'john@leilaodogalpao.com.br', password: 'password123'
    )
    batch = Batch.create!(
      code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
      min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
      creator: admin_user
    )

    login_as(admin_user)
    visit root_path
    click_on 'Listar Lotes'
    click_on 'Lote COD123456'

    expect(page).to have_content 'Lote COD123456'
    expect(page).to have_content 'Administrado por John Doe <john@leilaodogalpao.com.br>'
    expect(page).to have_content "Data de Início: #{batch.start_date.strftime('%d/%m/%Y')}"
    expect(page).to have_content "Data do Fim: #{batch.end_date.strftime('%d/%m/%Y')}"
    expect(page).to have_content 'Lance Mínimo: 10000 centavos'
    expect(page).to have_content 'Diferença Mínima Entre Lances: 5000 centavos'
  end

  it 'should show products linked to it' do
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
      name: 'Quadro', weight: 1_000,
      width: 30, height: 50, depth: 5,
      batch: batch
    )

    login_as(admin_user)
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
    batch = Batch.create!(
      code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
      min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
      creator: admin_user
    )

    login_as(admin_user)
    visit root_path
    click_on 'Listar Lotes'
    click_on 'Lote COD123456'

    expect(page).to have_content 'Não existem produtos vinculados a este lote.'
  end

  context 'when is a visitant' do
    it 'should be able to visit a approved batch' do
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
  
      visit root_path
      click_on 'Listar Lotes'
      click_on 'Lote COD123456'
      
      expect(current_path).to eq batch_path(batch)
      expect(page).to have_content 'Aprovado por Steve Gates'
    end

    it 'should not be able to visit a batch awaiting approval' do
      admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      batch = Batch.create!(
        code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: admin_user
      )
  
      visit batch_path(batch)
      
      expect(current_path).not_to eq batch_path(batch)
    end

    it 'should not see the button to add a product to the batch' do
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

      visit root_path
      click_on 'Listar Lotes'
      click_on 'Lote COD123456'
  
      expect(page).not_to have_field 'product_id'
      expect(page).not_to have_button 'Adicionar'
    end
  end

  context 'when is not a admin' do
    it 'should be able to visit a approved batch' do
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
  
      login_as(peter)
      visit batch_path(batch)
      
      expect(current_path).to eq batch_path(batch)
      expect(page).to have_content 'Aprovado por Steve Gates'
    end

    it 'should not be able to visit a batch awaiting approval' do
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
  
      login_as(peter)
      visit batch_path(batch)
      
      expect(current_path).not_to eq batch_path(batch)
    end

    it 'should not see the button to add a product to the batch' do
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

      login_as(peter)
      visit root_path
      click_on 'Listar Lotes'
      click_on 'Lote COD123456'
  
      expect(page).not_to have_field 'product_id'
      expect(page).not_to have_button 'Adicionar'
    end
  end

  context 'when is a admin' do
    it 'should be able to visit a approved batch' do
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
  
      login_as(john_admin)
      visit root_path
      click_on 'Listar Lotes'
      click_on 'Lote COD123456'
      
      expect(current_path).to eq batch_path(batch)
      expect(page).to have_content 'Aprovado por Steve Gates'
    end

    it 'should be able to visit a batch awaiting approval' do
      john_admin = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      batch = Batch.create!(
        code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: john_admin
      )
  
      login_as(john_admin)
      visit root_path
      click_on 'Listar Lotes'
      click_on 'Lote COD123456'
      
      expect(current_path).to eq batch_path(batch)
    end

    it 'should see the button to add a product to the batch' do
      john_admin = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      batch = Batch.create!(
        code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.day,
        min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
        creator: john_admin
      )

      login_as(john_admin)
      visit root_path
      click_on 'Listar Lotes'
      click_on 'Lote COD123456'
  
      expect(page).to have_field 'product_id'
      expect(page).to have_button 'Adicionar'
    end

    it 'should see the button to approve the batch if it was not created by him' do
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
        creator: steve_admin
      )

      login_as(john_admin)
      visit root_path
      click_on 'Listar Lotes'
      click_on 'Lote COD123456'
  
      expect(page).to have_button 'Aprovar Lote'
    end

    it 'should not see the button to approve the batch if it was created by him' do
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
        creator: steve_admin
      )

      login_as(steve_admin)
      visit root_path
      click_on 'Listar Lotes'
      click_on 'Lote COD123456'
  
      expect(page).not_to have_button 'Aprovar Lote'
    end
  end
end
