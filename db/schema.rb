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

ActiveRecord::Schema[8.0].define(version: 2025_06_22_202545) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
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
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "banner_photos", force: :cascade do |t|
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", limit: 25, null: false
    t.string "description", limit: 200
    t.string "image_url", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "customizations", force: :cascade do |t|
    t.integer "menu_item_id", null: false
    t.string "name", limit: 100
    t.float "price_adjustment"
    t.boolean "is_default", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["menu_item_id"], name: "index_customizations_on_menu_item_id"
  end

  create_table "loyalty_cards", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "punches_count", default: 0, null: false
    t.decimal "discount_amount", precision: 10, scale: 2, default: "8.0", null: false
    t.boolean "is_completed", default: false, null: false
    t.boolean "is_redeemed", default: false, null: false
    t.datetime "completed_at"
    t.datetime "redeemed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "is_completed"], name: "index_loyalty_cards_on_user_id_and_is_completed"
    t.index ["user_id", "is_redeemed"], name: "index_loyalty_cards_on_user_id_and_is_redeemed"
    t.index ["user_id"], name: "index_loyalty_cards_on_user_id"
  end

  create_table "loyalty_punches", force: :cascade do |t|
    t.integer "loyalty_card_id", null: false
    t.integer "order_id", null: false
    t.integer "punch_number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "receipt_upload_id", null: false
    t.index ["loyalty_card_id", "order_id"], name: "index_loyalty_punches_on_loyalty_card_id_and_order_id", unique: true
    t.index ["loyalty_card_id"], name: "index_loyalty_punches_on_loyalty_card_id"
    t.index ["order_id"], name: "index_loyalty_punches_on_order_id"
    t.index ["punch_number"], name: "index_loyalty_punches_on_punch_number"
    t.index ["receipt_upload_id"], name: "index_loyalty_punches_on_receipt_upload_id"
  end

  create_table "menu_items", force: :cascade do |t|
    t.string "name", limit: 100, null: false
    t.text "description"
    t.float "price", null: false
    t.string "image_url", limit: 255
    t.integer "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_menu_items_on_category_id"
  end

  create_table "order_item_customizations", force: :cascade do |t|
    t.integer "order_item_id", null: false
    t.string "customization_name", limit: 100
    t.float "price_adjustment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_item_id"], name: "index_order_item_customizations_on_order_item_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.integer "order_id", null: false
    t.integer "menu_item_id", null: false
    t.integer "quantity", default: 1, null: false
    t.float "item_price", null: false
    t.string "item_name", limit: 100, null: false
    t.string "special_request", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["menu_item_id"], name: "index_order_items_on_menu_item_id"
    t.index ["order_id"], name: "index_order_items_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "user_id", null: false
    t.datetime "order_date", null: false
    t.string "status", limit: 25, null: false
    t.string "contact_name", limit: 25
    t.string "contact_phone", limit: 20
    t.string "contact_email", limit: 120
    t.float "subtotal", default: 0.0, null: false
    t.float "tax", default: 0.0, null: false
    t.float "total_amount", default: 0.0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "receipt_uploads", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "loyalty_card_id"
    t.string "status", default: "pending", null: false
    t.text "admin_notes"
    t.datetime "approved_at"
    t.integer "approved_by_id"
    t.decimal "receipt_total", precision: 10, scale: 2
    t.date "receipt_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approved_by_id"], name: "index_receipt_uploads_on_approved_by_id"
    t.index ["loyalty_card_id"], name: "index_receipt_uploads_on_loyalty_card_id"
    t.index ["status"], name: "index_receipt_uploads_on_status"
    t.index ["user_id", "status"], name: "index_receipt_uploads_on_user_id_and_status"
    t.index ["user_id"], name: "index_receipt_uploads_on_user_id"
  end

  create_table "restaurant_infos", force: :cascade do |t|
    t.string "name", limit: 100
    t.string "street", limit: 100
    t.string "city", limit: 100
    t.string "state", limit: 100
    t.string "zip_code", limit: 20
    t.string "phone", limit: 20
    t.string "email", limit: 100
    t.string "logo_url", limit: 225
    t.string "monday_hours", limit: 50
    t.string "tuesday_hours", limit: 20
    t.string "wednesday_hours", limit: 20
    t.string "thursday_hours", limit: 20
    t.string "friday_hours", limit: 20
    t.string "saturday_hours"
    t.string "sunday_hours"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", limit: 25, null: false
    t.string "last_name", limit: 25, null: false
    t.string "username", limit: 25, null: false
    t.string "email", limit: 25, null: false
    t.string "phone", limit: 20
    t.string "password_digest", limit: 25, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false, null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "customizations", "menu_items"
  add_foreign_key "loyalty_cards", "users"
  add_foreign_key "loyalty_punches", "loyalty_cards"
  add_foreign_key "loyalty_punches", "orders"
  add_foreign_key "loyalty_punches", "receipt_uploads"
  add_foreign_key "menu_items", "categories"
  add_foreign_key "order_item_customizations", "order_items"
  add_foreign_key "order_items", "menu_items"
  add_foreign_key "order_items", "orders"
  add_foreign_key "orders", "users"
  add_foreign_key "receipt_uploads", "loyalty_cards"
  add_foreign_key "receipt_uploads", "users"
  add_foreign_key "receipt_uploads", "users", column: "approved_by_id"
end
