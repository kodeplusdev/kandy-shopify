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

ActiveRecord::Schema.define(version: 20151215072119) do

  create_table "conversations", force: :cascade do |t|
    t.string   "name"
    t.string   "status",            default: "open"
    t.text     "messages",          default: "[]"
    t.string   "rating",            default: "none"
    t.integer  "shop_id"
    t.integer  "visitor_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "email"
    t.text     "location",          default: "{}"
    t.boolean  "deleted",           default: false
    t.boolean  "archived",          default: false
    t.integer  "first_operator_id"
  end

  add_index "conversations", ["shop_id"], name: "index_conversations_on_shop_id"
  add_index "conversations", ["visitor_id"], name: "index_conversations_on_visitor_id"

  create_table "conversations_users", force: :cascade do |t|
    t.integer "user_id"
    t.integer "conversation_id"
  end

  add_index "conversations_users", ["conversation_id"], name: "index_conversations_users_on_conversation_id"
  add_index "conversations_users", ["user_id"], name: "index_conversations_users_on_user_id"

  create_table "kandy_users", force: :cascade do |t|
    t.string   "username"
    t.string   "email"
    t.string   "password"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone_number"
    t.string   "api_key"
    t.string   "api_secret"
    t.string   "country_code"
    t.string   "domain_name"
    t.integer  "shop_id"
    t.integer  "user_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "kandy_users", ["shop_id"], name: "index_kandy_users_on_shop_id"
  add_index "kandy_users", ["user_id"], name: "index_kandy_users_on_user_id"

  create_table "settings", force: :cascade do |t|
    t.string   "var",                   null: false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", limit: 30
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true

  create_table "shops", force: :cascade do |t|
    t.string   "shopify_domain",                      null: false
    t.string   "shopify_token",                       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "kandy_api_key"
    t.string   "kandy_api_secret"
    t.integer  "kandy_user_guest_id"
    t.boolean  "initialized",         default: false
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

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",            null: false
    t.string   "encrypted_password",     default: "",            null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,             null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.datetime "last_seen"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",      default: 0
    t.string   "role",                   default: "operator"
    t.integer  "shop_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone_number"
    t.string   "avatar"
    t.string   "status",                 default: "unavailable"
    t.integer  "kandy_user_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count"
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id"
  add_index "users", ["kandy_user_id"], name: "index_users_on_kandy_user_id"
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["shop_id"], name: "index_users_on_shop_id"

  create_table "widgets", force: :cascade do |t|
    t.string   "name",                            null: false
    t.boolean  "enabled",     default: true
    t.string   "color",       default: "#000000"
    t.text     "json_string"
    t.integer  "shop_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "widgets", ["shop_id"], name: "index_widgets_on_shop_id"

end
