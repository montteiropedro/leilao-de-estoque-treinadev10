require 'rails_helper'

describe 'User visits homepage' do
  it 'should see a link "Leilão do Estoque"' do
    visit root_path

    expect(page).to have_link 'Leilão do Estoque', href: root_path
  end

  context 'visitant or non admin user' do
    it 'should see the user menu' do
      visit root_path

      expect(page).to have_content 'Menu'
      expect(page).to have_link 'Lotes em Leilão', href: batches_path
    end
  end

  context 'admin user' do
    it 'should see the admin menu' do
      admin_user = User.create!(
        name: 'John Doe', cpf: '41760209031',
        email: 'john@leilaodogalpao.com.br', password: 'password123'
      )

      login_as(admin_user)
      visit root_path

      expect(page).to have_content 'Admin Menu'
      expect(page).to have_link 'Aprovar Lotes' # todo: yet to implement
      expect(page).to have_link 'Cadastrar Lotes', href: new_batch_path
      expect(page).to have_link 'Cadastrar Produtos', href: new_product_path
      expect(page).to have_link 'Cadastrar Categorias', href: new_category_path
    end
  end
end
