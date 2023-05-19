require 'rails_helper'

describe 'Admin tries to unblocks a CPF' do
  it "should be successful" do
    admin_user = User.create!(
      name: 'John Doe', cpf: '41760209031',
      email: 'john@leilaodogalpao.com.br', password: 'password123'
    )
    BlockedCpf.create!(cpf: '63420176031')

    login_as admin_user
    visit root_path
    within('nav') do
      click_on 'Bloquear CPF'
    end

    within('section#blocked-cpfs') do
      click_on 'Desbloquear'
    end

    expect(page).to have_content 'CPF desbloqueado com sucesso.'
    within('section#blocked-cpfs') do
      expect(page).not_to have_content '634.201.760-31'
    end
  end
end
