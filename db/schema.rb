# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151005045008) do

  create_table "shops", force: :cascade do |t|
    t.string   "shopify_domain",     null: false
    t.string   "shopify_token",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "kandy_api_key"
    t.string   "kandy_api_secret"
    t.string   "kandy_phone_number"
    t.string   "kandy_username"
    t.string   "kandy_token"
    t.string   "sms_order_template"
  end

  add_index "shops", ["shopify_domain"], name: "index_shops_on_shopify_domain", unique: true

  create_table "templates", force: :cascade do |t|
    t.string   "order_creation"
    t.string   "order_update"
    t.string   "order_payment"
    t.string   "customer_creation"
    t.integer  "shop_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "templates", ["shop_id"], name: "index_templates_on_shop_id"

end
