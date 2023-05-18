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

ActiveRecord::Schema[7.0].define(version: 2023_05_18_134010) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.integer "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "bids", force: :cascade do |t|
    t.integer "value_in_centavos", null: false
    t.integer "user_id", null: false
    t.integer "lot_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lot_id"], name: "index_bids_on_lot_id"
    t.index ["user_id"], name: "index_bids_on_user_id"
  end

  create_table "blocked_cpfs", force: :cascade do |t|
    t.string "cpf", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cpf"], name: "index_blocked_cpfs_on_cpf", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "lots", force: :cascade do |t|
    t.string "code", null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.integer "min_bid_in_centavos", null: false
    t.integer "min_diff_between_bids_in_centavos", null: false
    t.integer "creator_id", null: false
    t.integer "approver_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "buyer_id"
    t.index ["approver_id"], name: "index_lots_on_approver_id"
    t.index ["buyer_id"], name: "index_lots_on_buyer_id"
    t.index ["code"], name: "index_lots_on_code", unique: true
    t.index ["creator_id"], name: "index_lots_on_creator_id"
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
    t.integer "lot_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["code"], name: "index_products_on_code", unique: true
    t.index ["lot_id"], name: "index_products_on_lot_id"
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

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "bids", "lots"
  add_foreign_key "bids", "users"
  add_foreign_key "lots", "users", column: "approver_id"
  add_foreign_key "lots", "users", column: "buyer_id"
  add_foreign_key "lots", "users", column: "creator_id"
  add_foreign_key "products", "categories"
  add_foreign_key "products", "lots"
end
