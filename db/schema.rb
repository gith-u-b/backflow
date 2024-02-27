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

ActiveRecord::Schema[7.0].define(version: 2024_02_27_070608) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cart_items", force: :cascade do |t|
    t.integer "cart_id"
    t.integer "product_id"
    t.integer "shop_id"
    t.string "product_name"
    t.text "sku"
    t.string "sku_key"
    t.integer "number"
    t.decimal "price", precision: 10, scale: 2, default: "0.0"
    t.decimal "origin_price", precision: 10, scale: 2, default: "0.0"
    t.string "prc"
    t.boolean "is_selected", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cart_id"], name: "index_cart_items_on_cart_id"
    t.index ["shop_id"], name: "index_cart_items_on_shop_id"
  end

  create_table "carts", force: :cascade do |t|
    t.integer "user_id"
    t.integer "contact_id"
    t.integer "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contacts", force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.string "country"
    t.string "province"
    t.string "city"
    t.string "town"
    t.string "address"
    t.string "postcode"
    t.string "phone"
    t.string "remark"
    t.boolean "active", default: true
    t.boolean "is_default", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.integer "user_id"
    t.integer "shop_id"
    t.string "name"
    t.string "description"
    t.decimal "price", precision: 10, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shops", force: :cascade do |t|
    t.integer "company_id"
    t.string "name"
    t.string "address"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_signin_logs", force: :cascade do |t|
    t.integer "user_id"
    t.string "ip"
    t.string "ip_country"
    t.string "ip_province"
    t.string "ip_city"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.string "nickname"
    t.string "sign"
    t.string "api_token"
    t.boolean "is_admin", default: false
    t.integer "signin_count", default: 0
    t.datetime "current_signin_at"
    t.string "current_signin_ip"
    t.datetime "last_signin_at"
    t.string "last_signin_ip"
    t.string "create_ip"
    t.string "create_ip_country"
    t.string "create_ip_province"
    t.string "create_ip_city"
    t.integer "current_conins", default: 0
    t.boolean "is_enabled", default: true
    t.string "promo_code"
    t.integer "promo_users_count"
    t.integer "promo_user_id"
    t.integer "binded_promo_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
