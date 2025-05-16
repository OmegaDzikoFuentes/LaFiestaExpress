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

ActiveRecord::Schema[8.0].define(version: 2025_05_16_231019) do
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

  create_table "restaurant_infos", force: :cascade do |t|
    t.string "name", limit: 100
    t.string "street", limit: 100
    t.string "city", limit: 100
    t.string "state", limit: 100
    t.string "zip_code", limit: 20
    t.string "phone", limit: 20
    t.string "email", limit: 100
    t.string "logo_url", limit: 225
    t.string "mondaay_hours", limit: 50
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
    t.string "password", limit: 25, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false, null: false
  end

  add_foreign_key "customizations", "menu_items"
  add_foreign_key "menu_items", "categories"
  add_foreign_key "order_item_customizations", "order_items"
  add_foreign_key "order_items", "menu_items"
  add_foreign_key "order_items", "orders"
  add_foreign_key "orders", "users"
end
