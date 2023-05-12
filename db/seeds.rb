# Users and Admins

john_admin = User.create!(
  name: 'John Doe', cpf: '41760209031',
  email: 'john@leilaodogalpao.com.br', password: 'password123'
)

steve_admin = User.create!(
  name: 'Steve Gates', cpf: '35933681024',
  email: 'steve@leilaodogalpao.com.br', password: 'password123'
)

peter = User.create!(
  name: 'Peter Parker', cpf: '73046259026',
  email: 'peter@email.com', password: 'password123'
)

# Batches

approved_batch = Batch.create!(
  code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.month,
  min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
  creator: john_admin, approver: steve_admin
)

Batch.create!(
  code: 'BTC334509', start_date: Date.today, end_date: Date.today + 2.month,
  min_bid_in_centavos: 15_000, min_diff_between_bids_in_centavos: 10_000,
  creator: john_admin
)

Batch.create!(
  code: 'SSH202312', start_date: Date.today, end_date: Date.today + 2.weeks,
  min_bid_in_centavos: 50_000, min_diff_between_bids_in_centavos: 5_000,
  creator: steve_admin
)

expired_approved_batch = Batch.new(
  code: 'KDA334509', start_date: Date.today - 2.weeks, end_date: Date.today - 1.week,
  min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 3_000,
  creator: john_admin, approver: steve_admin
)
expired_approved_batch.save!(validate: false)

Batch.new(
  code: 'ZUZ202305', start_date: Date.today - 1.weeks, end_date: Date.today - 3.days,
  min_bid_in_centavos: 35_000, min_diff_between_bids_in_centavos: 5_000,
  creator: steve_admin
).save!(validate: false)

# Bids

Bid.new(value_in_centavos: 10_500, user: peter, batch: expired_approved_batch).save!(validate: false)

# Categories

household_appliances_category = Category.create!(name: 'Eletrodomésticos')
tech_category = Category.create!(name: 'Informática')
household_items_category = Category.create!(name: 'Utensílios Domésticos')
decoration_category = Category.create!(name: 'Casa e Decoração')

# Products

frame = Product.create!(
  name: 'Quadro', weight: 1_000, description: 'Quadro com a imagem de um hamburger.',
  width: 30, height: 50, depth: 5, category: decoration_category
)

tv_samsung = Product.create!(
  name: 'TV 60 Polegadas', weight: 5_000, description: 'Televisão Samsung de 60 Polegadas.',
  width: 100, height: 50, depth: 10, category: household_appliances_category,
  batch: approved_batch
)

webcam_logitech = Product.create!(
  name: 'Webcam C720 Logitech', weight: 500,
  width: 100, height: 50, depth: 10, category: tech_category,
  batch: approved_batch
)

game_ghost_of_tsushima = Product.create!(
  name: 'Ghost of Tsushima', weight: 300, description: 'Ghost of Tsushima - PS4',
  width: 15, height: 30, depth: 5,
  batch: expired_approved_batch
)

game_uncharted = Product.create!(
  name: 'Uncharted', weight: 300,
  width: 15, height: 30, depth: 5,
)
