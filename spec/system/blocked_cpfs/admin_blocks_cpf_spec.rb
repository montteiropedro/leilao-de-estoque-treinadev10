require 'rails_helper'

describe 'Admin tries to blocks a CPF' do
  it "should be successful if it hasn't been blocked already" do
    admin_user = User.create!(
      name: 'John Doe', cpf: '41760209031',
      email: 'john@leilaodogalpao.com.br', password: 'password123'
    )

    login_as admin_user
    visit root_path
    within('nav') do
      click_on 'Bloquear CPF'
    end

    fill_in 'cpf', with: '63420176031'
    click_on 'Bloquear'

    expect(page).to have_content 'CPF bloqueado com sucesso.'
    within('section#blocked-cpfs') do
      expect(page).to have_content '634.201.760-31'
    end
  end

  it "should be unsuccessful if it has been blocked already" do
    admin_user = User.create!(
      name: 'John Doe', cpf: '41760209031',
      email: 'john@leilaodogalpao.com.br', password: 'password123'
    )
    blocked_cpf_a = BlockedCpf.create!(cpf: '63420176031')

    login_as admin_user
    visit root_path
    within('nav') do
      click_on 'Bloquear CPF'
    end

    fill_in 'cpf', with: '63420176031'
    click_on 'Bloquear'

    expect(page).to have_content 'CPF inválido ou já bloqueado.'
    within('section#blocked-cpfs') do
      expect(page).to have_content '634.201.760-31'
    end
  end

  it "should be unsuccessful if it is invalid" do
    admin_user = User.create!(
      name: 'John Doe', cpf: '41760209031',
      email: 'john@leilaodogalpao.com.br', password: 'password123'
    )

    login_as admin_user
    visit root_path
    within('nav') do
      click_on 'Bloquear CPF'
    end

    fill_in 'cpf', with: '123456'
    click_on 'Bloquear'

    expect(page).to have_content 'CPF inválido ou já bloqueado.'
    within('section#blocked-cpfs') do
      expect(page).not_to have_content '123456'
    end
  end
end
