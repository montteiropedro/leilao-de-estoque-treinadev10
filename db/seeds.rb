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

# Lots

approved_lot = Lot.create!(
  code: 'COD123456', start_date: Date.today, end_date: Date.today + 1.month,
  min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
  creator: john_admin, approver: steve_admin
)

expired_approved_lot = Lot.new(
  code: 'KDA334509', start_date: Date.today - 2.weeks, end_date: Date.today - 1.week,
  min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 3_000,
  creator: john_admin, approver: steve_admin
)
expired_approved_lot.save!(validate: false)

Lot.new(
  code: 'BTC334509', start_date: Date.today - 1.day, end_date: Date.today + 2.weeks,
  min_bid_in_centavos: 15_000, min_diff_between_bids_in_centavos: 10_000,
  creator: john_admin
).save!(validate: false)

Lot.create!(
  code: 'SSH202312', start_date: Date.today, end_date: Date.today + 2.weeks,
  min_bid_in_centavos: 50_000, min_diff_between_bids_in_centavos: 5_000,
  creator: steve_admin
)

Lot.new(
  code: 'ZUZ202305', start_date: Date.today - 1.weeks, end_date: Date.today - 3.days,
  min_bid_in_centavos: 35_000, min_diff_between_bids_in_centavos: 5_000,
  creator: steve_admin
).save!(validate: false)

Lot.new(
  code: 'KRT992546', start_date: Date.today - 3.days, end_date: Date.today + 1.week,
  min_bid_in_centavos: 35_000, min_diff_between_bids_in_centavos: 5_000,
  creator: steve_admin
).save!(validate: false)

# Bids + Sold Lot

sold_lot = Lot.new(
  code: 'AKZ230513', start_date: Date.today - 1.week, end_date: Date.today - 1.day,
  min_bid_in_centavos: 10_000, min_diff_between_bids_in_centavos: 5_000,
  creator: john_admin, approver: steve_admin, buyer: peter
)
sold_lot.save!(validate: false)

Bid.new(value_in_centavos: 10_500, user: peter, lot: sold_lot).save!(validate: false)

# Categories

household_appliances_category = Category.create!(name: 'Eletrodomésticos')
tech_category = Category.create!(name: 'Informática')
games_category = Category.create!(name: 'Jogos Eletrônicos')
household_items_category = Category.create!(name: 'Utensílios Domésticos')
decoration_category = Category.create!(name: 'Casa e Decoração')

# Products

Product.create!(
  name: 'Quadro', weight: 1_000, description: 'Quadro com a imagem de um hamburger.',
  width: 30, height: 50, depth: 5, category: decoration_category
)

Product.create!(
  name: 'Teclado Mecânico', weight: 1_000, description: 'Teclado Mecânico Logitech.',
  width: 30, height: 10, depth: 3
)

Product.create!(
  name: 'TV 60 Polegadas', weight: 5_000, description: 'Televisão Samsung de 60 Polegadas.',
  width: 100, height: 50, depth: 10, category: household_appliances_category,
  lot: approved_lot
)

Product.create!(
  name: 'Webcam C720 Logitech', weight: 500,
  width: 100, height: 50, depth: 10, category: tech_category,
  lot: approved_lot
)

Product.create!(
  name: 'Uncharted 3', weight: 300, description: 'Uncharted 3, Naughty Dog - PS3',
  width: 15, height: 30, depth: 5, category: games_category,
  lot: expired_approved_lot
)

Product.create!(
  name: 'Ghost of Tsushima', weight: 300, description: 'Ghost of Tsushima - PS4',
  width: 15, height: 30, depth: 5, category: games_category,
  lot: sold_lot
)

Product.create!(
  name: 'Grand Theft Auto V', weight: 300, description: 'GTA 5, Rockstar Games - PS4',
  width: 15, height: 30, depth: 5,
  lot: sold_lot
)

Product.create!(
  name: 'God of War', weight: 300, description: 'God of War: Ragnarok, Santa Monica Studio - PS4, PS5',
  width: 15, height: 30, depth: 5, category: games_category,
  lot: sold_lot
)
