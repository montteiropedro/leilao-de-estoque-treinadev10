require 'rails_helper'

describe 'Admin visits block CPF/list blocked CPFs page' do
  it 'from menu' do
    admin_user = User.create!(
      name: 'John Doe', cpf: '41760209031',
      email: 'john@leilaodogalpao.com.br', password: 'password123'
    )

    login_as admin_user
    visit root_path
    within('nav') do
      click_on 'Bloquear CPF'
    end

    expect(current_path).to eq blocked_cpfs_path
    expect(page).to have_css 'h1', text: 'Bloquear CPF / Listar CPFs Bloqueados'
  end

  context 'and the block session' do
    it 'should have a form to block a CPF' do
      admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
  
      login_as admin_user
      visit root_path
      click_on 'Bloquear CPF'
  
      within('section#block-cpf') do
        expect(page).to have_css 'h2', text: 'Bloquear CPF'
        within('form') do
          expect(page).to have_field 'cpf'
          expect(page).to have_css 'input[placeholder="Digite o CPF sem pontuações"]#cpf'
          expect(page).to have_button 'Bloquear'
        end
      end
    end
  end

  context 'and the blocked CPFs session' do
    it 'should list all blocked CPFs' do
      admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      blocked_cpf_a = BlockedCpf.create!(cpf: '63420176031')
      blocked_cpf_b = BlockedCpf.create!(cpf: '58542034058')
  
      login_as admin_user
      visit blocked_cpfs_path
  
      within('section#blocked-cpfs') do
        expect(page).to have_css 'h2', text: 'CPFs Bloqueados'
        expect(page).to have_content '634.201.760-31'
        expect(page).to have_content '585.420.340-58'
      end
    end

    it 'should show a message when there is no blocked CPF' do
      admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
  
      login_as admin_user
      visit blocked_cpfs_path
  
      within('section#blocked-cpfs') do
        expect(page).to have_css 'h2', text: 'CPFs Bloqueados'
        expect(page).to have_content 'Não existem CPFs bloqueados.'
      end
    end
  end
end
