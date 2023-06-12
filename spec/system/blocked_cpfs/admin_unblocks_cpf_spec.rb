require 'rails_helper'

describe 'Administrador desbloqueia um CPF' do
  it 'com sucesso' do
    admin_user = User.create!(
      name: 'John Doe', cpf: '41760209031',
      email: 'john@leilaodogalpao.com.br', password: 'password123'
    )
    BlockedCpf.create!(cpf: '63420176031')

    login_as admin_user
    visit root_path
    click_on 'Bloquear CPF'
    within '#blocked-cpfs' do
      click_on 'Desbloquear'
    end

    expect(page).to have_content 'CPF desbloqueado com sucesso.'
    within '#blocked-cpfs' do
      expect(page).not_to have_content '634.201.760-31'
    end
  end
end
