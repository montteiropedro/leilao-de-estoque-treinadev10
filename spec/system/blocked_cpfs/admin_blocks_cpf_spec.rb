require 'rails_helper'

describe 'Administrador tenta bloquear um CPF' do
  it 'e tem sucesso quando o CPF ainda não esta bloqueado' do
    admin_user = User.create!(
      name: 'John Doe', cpf: '41760209031',
      email: 'john@leilaodogalpao.com.br', password: 'password123'
    )

    login_as admin_user
    visit root_path
    click_on 'Bloquear / Desbloquear CPF'

    fill_in 'cpf', with: '63420176031'
    click_on 'Bloquear'

    expect(page).to have_content 'CPF bloqueado com sucesso.'
    within '#blocked-cpfs' do
      expect(page).to have_content '634.201.760-31'
    end
  end

  it 'e não tem sucesso quando o CPF já está bloqueado' do
    admin_user = User.create!(
      name: 'John Doe', cpf: '41760209031',
      email: 'john@leilaodogalpao.com.br', password: 'password123'
    )
    BlockedCpf.create!(cpf: '63420176031')

    login_as admin_user
    visit root_path
    click_on 'Bloquear / Desbloquear CPF'
    fill_in 'cpf', with: '63420176031'
    click_on 'Bloquear'

    expect(page).to have_content 'CPF inválido ou já bloqueado.'
    within '#blocked-cpfs' do
      expect(page).to have_content '634.201.760-31'
    end
  end

  it 'e não tem sucesso quando o CPF é inválido' do
    admin_user = User.create!(
      name: 'John Doe', cpf: '41760209031',
      email: 'john@leilaodogalpao.com.br', password: 'password123'
    )

    login_as admin_user
    visit root_path
    click_on 'Bloquear / Desbloquear CPF'
    fill_in 'cpf', with: '123456'
    click_on 'Bloquear'

    expect(page).to have_content 'CPF inválido ou já bloqueado.'
    within '#blocked-cpfs' do
      expect(page).not_to have_content '123456'
    end
  end
end
