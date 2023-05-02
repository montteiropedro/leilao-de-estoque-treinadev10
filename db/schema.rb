# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_05_02_140200) do
  create_table "batches", force: :cascade do |t|
    t.string "code", null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.integer "minimum_bid", null: false
    t.integer "minimum_difference_between_bids", null: false
    t.integer "creator_id", null: false
    t.integer "approver_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approver_id"], name: "index_batches_on_approver_id"
    t.index ["code"], name: "index_batches_on_code", unique: true
    t.index ["creator_id"], name: "index_batches_on_creator_id"
  end

  create_table "bids", force: :cascade do |t|
    t.integer "value", null: false
    t.integer "user_id", null: false
    t.integer "batch_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["batch_id"], name: "index_bids_on_batch_id"
    t.index ["user_id"], name: "index_bids_on_user_id"
    t.index ["value"], name: "index_bids_on_value", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "products", force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
    t.string "description"
    t.integer "weight"
    t.integer "width"
    t.integer "height"
    t.integer "depth"
    t.integer "category_id"
    t.integer "batch_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["batch_id"], name: "index_products_on_batch_id"
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["code"], name: "index_products_on_code", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name", null: false
    t.string "cpf", limit: 11, null: false
    t.boolean "is_admin", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cpf"], name: "index_users_on_cpf", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "batches", "users", column: "approver_id"
  add_foreign_key "batches", "users", column: "creator_id"
  add_foreign_key "bids", "batches"
  add_foreign_key "bids", "users"
  add_foreign_key "products", "batches"
  add_foreign_key "products", "categories"
end
