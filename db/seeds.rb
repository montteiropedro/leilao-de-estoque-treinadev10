# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Users

first_admin_user = User.new(
  name: 'John Doe', cpf: '41760209031',
  email: 'john@leilaodogalpao.com.br', password: 'password123'
)

second_admin_user = User.new(
  name: 'Steve Gates', cpf: '41760209031',
  email: 'steve@leilaodogalpao.com.br', password: 'password123'
)

user = User.new(
  name: 'Peter Parker', cpf: '73046259026',
  email: 'peter@email.com', password: 'password123'
)

# Categories

electronics_category = Category.new(name: 'Eletrônicos')
household_items_category = Category.new(name: 'Utensílios Domésticos')
decoration_category = Category.new(name: 'Casa e Decoração')

# Products

product_without_category = Product.new(
  name: 'Quadro', weight: 1_000,
  width: 30, height: 50, depth: 5
)

product_with_category = Product.new(
  name: 'TV 32 Polegadas', weight: 5_000,
  width: 100, height: 50, depth: 10,
  category: electronics_category
)

# Batch

batch = Batch.new(
  code: 'COD123456', start_date: '2023-10-05', end_date: '2023-12-20',
  minimum_bid: 10_000, minimum_difference_between_bids: 5_000,
  creator: first_admin_user
)

batch = Batch.new(
  code: 'BTC334509', start_date: '2023-11-10', end_date: '2023-12-01',
  minimum_bid: 15_000, minimum_difference_between_bids: 10_000,
  creator: first_admin_user, approver: second_admin_user
)
