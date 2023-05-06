require 'rails_helper'

describe 'User views all registered categories' do
  it 'from menu' do
    visit root_path
    within('#category-menu') do
      click_on 'Listar Categorias'
    end

    expect(current_path).to eq categories_path
    expect(page).to have_content('Categorias')
  end

  it 'should be successful' do
    Category.create!(name: 'Eletrônicos')
    Category.create!(name: 'Utensílios Domésticos')

    visit root_path
    click_on 'Listar Categorias'

    expect(page).to have_link 'Eletrônicos'
    expect(page).to have_link 'Utensílios Domésticos'
  end

  it 'and should see a message when there is no category registered' do
    visit root_path
    click_on 'Listar Categorias'

    expect(page).to have_content 'Não existem categorias cadastradas.'
  end
end
