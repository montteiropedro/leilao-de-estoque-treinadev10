require 'rails_helper'

describe 'Usuário visita a tela de listagem de categorias de produtos' do
  it 'partindo do menu de categorias' do
    visit root_path
    within '#category-menu' do
      click_on 'Listar Categorias'
    end

    expect(current_path).to eq categories_path
    expect(page).to have_content('Categorias')
  end

  context 'e quando existem categorias cadastradas na aplicação' do
    it 'deve ser exibido um link para a página de detalhes de cada categoria' do
      Category.create!(name: 'Eletrônicos')
      Category.create!(name: 'Utensílios Domésticos')

      visit categories_path

      expect(page).to have_link 'Eletrônicos'
      expect(page).to have_link 'Utensílios Domésticos'
    end
  end

  context 'e quando não existem categorias cadastradas na aplicação' do
    it 'deve vêr uma mensagem' do
      visit categories_path

      expect(page).to have_content 'Não existem categorias cadastradas.'
    end
  end
end
