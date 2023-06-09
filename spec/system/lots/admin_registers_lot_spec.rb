require 'rails_helper'

describe 'Admin registers a lot' do
  it 'from admin menu' do
    admin_user = User.create!(
      name: 'John Doe', cpf: '41760209031',
      email: 'john@leilaodogalpao.com.br', password: 'password123'
    )

    login_as(admin_user)
    visit root_path
    within('#lot-menu') do
      click_on 'Cadastrar Lotes'
    end

    expect(current_path).to eq new_lot_path
    expect(page).to have_content 'Cadastrar Novo Lote'
    expect(page).to have_field 'Código'
    expect(page).to have_field 'Data de Início'
    expect(page).to have_field 'Data do Fim'
    expect(page).to have_field 'Lance Mínimo'
    expect(page).to have_css 'input[placeholder="Valor em reais"]#lot_min_bid_in_reais'
    expect(page).to have_field 'Diferença Mínima Entre Lances'
    expect(page).to have_css 'input[placeholder="Valor em reais"]#lot_min_diff_between_bids_in_reais'
  end

  context 'admin user' do
    it 'should be sucessful with valid data' do
      admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
  
      login_as(admin_user)
      visit root_path
      click_on 'Cadastrar Lotes'
      fill_in 'Código', with: 'COD123456'
      fill_in 'Data de Início', with: '10/10/2023'
      fill_in 'Data do Fim', with: '01/12/2023'
      fill_in 'Lance Mínimo', with: 100
      fill_in 'Diferença Mínima Entre Lances', with: 50
      click_on 'Cadastrar'

      expect(current_path).to eq lot_path(Lot.last)
      expect(page).to have_content 'Lote cadastrado com sucesso.'
    end

    it 'should not be sucessful with invalid data' do
      admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
  
      login_as(admin_user)
      visit root_path
      click_on 'Cadastrar Lotes'
      fill_in 'Código', with: ''
      fill_in 'Data de Início', with: ''
      fill_in 'Data do Fim', with: ''
      fill_in 'Lance Mínimo', with: ''
      fill_in 'Diferença Mínima Entre Lances', with: ''
      click_on 'Cadastrar'

      expect(current_path).to eq lots_path
      expect(page).to have_content 'Falha ao cadastrar o lote.'
    end
  end

  context 'visitant' do
    it 'should be redirected to homepage' do
      visit new_lot_path
  
      expect(current_path).to eq new_user_session_path
    end
  end

  context 'non admin user' do
    it 'should be redirected to homepage' do
      user = User.create!(
        name: 'Peter Parker', cpf: '73046259026',
        email: 'peter@email.com', password: 'password123'
      )
  
      login_as(user)
      visit new_lot_path
  
      expect(current_path).to eq root_path
    end
  end
end
