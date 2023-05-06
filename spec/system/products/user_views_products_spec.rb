require 'rails_helper'

describe 'User views all registered products' do
  it 'from menu' do
    visit root_path
    within('#product-menu') do
      click_on 'Listar Produtos'
    end

    expect(current_path).to eq products_path
    expect(page).to have_content('Produtos')
  end

  it 'should be successful' do
    Product.create!(
      name: 'TV 32 Polegadas', weight: 5_000,
      width: 100, height: 50, depth: 10
    )
    Product.create!(
      name: 'Quadro', weight: 1_000,
      width: 30, height: 50, depth: 5
    )

    visit root_path
    click_on 'Listar Produtos'

    expect(page).to have_link 'TV 32 Polegadas'
    expect(page).to have_link 'Quadro'
  end

  it 'and should see a message when there is no product registered' do
    visit root_path
    click_on 'Listar Produtos'

    expect(page).to have_content 'Não existem produtos cadastrados.'
  end
end
