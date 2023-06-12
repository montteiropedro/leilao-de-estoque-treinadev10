require 'rails_helper'

describe 'Administrador visita a tela de bloqueio/desbloqueio de CPFs' do
  it 'partindo da barra de navegação' do
    admin_user = User.create!(
      name: 'John Doe', cpf: '41760209031',
      email: 'john@leilaodogalpao.com.br', password: 'password123'
    )

    login_as admin_user
    visit root_path
    within 'nav' do
      click_on 'Bloquear / Desbloquear CPF'
    end

    expect(current_path).to eq blocked_cpfs_path
    expect(page).to have_css 'h1', text: 'Bloquear / Desbloquear CPF'
  end

  context 'e a sessão de bloquar CPF' do
    it 'deve exibir um formulário para fazer o bloqueio' do
      admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )

      login_as admin_user
      visit root_path
      click_on 'Bloquear CPF'

      within '#block-cpf' do
        expect(page).to have_css 'h2', text: 'Bloquear CPF'
        within 'form' do
          expect(page).to have_field 'cpf'
          expect(page).to have_css 'input[placeholder="Digite o CPF sem pontuações"]#cpf'
          expect(page).to have_button 'Bloquear'
        end
      end
    end
  end

  context 'e a sessão de CPFs bloqueados' do
    it 'deve listar todos os CPFs que estão em situação de bloqueio' do
      admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )
      BlockedCpf.create!(cpf: '63420176031')
      BlockedCpf.create!(cpf: '58542034058')

      login_as admin_user
      visit blocked_cpfs_path

      within '#blocked-cpfs' do
        expect(page).to have_css 'h2', text: 'CPFs Bloqueados'
        expect(page).to have_content '634.201.760-31'
        expect(page).to have_content '585.420.340-58'
      end
    end

    it 'deve exibir uma mensagem quando não existe CPF em situação de bloqueio' do
      admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )

      login_as admin_user
      visit blocked_cpfs_path

      within '#blocked-cpfs' do
        expect(page).to have_css 'h2', text: 'CPFs Bloqueados'
        expect(page).to have_content 'Não existem CPFs bloqueados.'
      end
    end
  end
end
