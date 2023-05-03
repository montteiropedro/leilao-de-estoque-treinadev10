first_admin_user = User.create!(
  name: 'John Doe', cpf: '41760209031',
  email: 'john@leilaodogalpao.com.br', password: 'password123'
)

second_admin_user = User.create!(
  name: 'Steve Gates', cpf: '35933681024',
  email: 'steve@leilaodogalpao.com.br', password: 'password123'
)

user = User.create!(
  name: 'Peter Parker', cpf: '73046259026',
  email: 'peter@email.com', password: 'password123'
)

# Categories

electronics_category = Category.create!(name: 'Eletrônicos')
household_items_category = Category.create!(name: 'Utensílios Domésticos')
decoration_category = Category.create!(name: 'Casa e Decoração')

# Products

product_without_category = Product.create!(
  name: 'Quadro', weight: 1_000,
  width: 30, height: 50, depth: 5
)

product_with_category = Product.create!(
  name: 'TV 32 Polegadas', weight: 5_000,
  width: 100, height: 50, depth: 10,
  category: electronics_category
)

# Batch

batch = Batch.create!(
  code: 'COD123456', start_date: '2023-10-05', end_date: '2023-12-20',
  minimum_bid: 10_000, minimum_difference_between_bids: 5_000,
  creator: first_admin_user
)

batch = Batch.create!(
  code: 'BTC334509', start_date: '2023-11-10', end_date: '2023-12-01',
  minimum_bid: 15_000, minimum_difference_between_bids: 10_000,
  creator: first_admin_user, approver: second_admin_user
)
