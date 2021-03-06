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

ActiveRecord::Schema.define(version: 20200324141052) do

  create_table "attempted_linkages", force: :cascade do |t|
    t.integer "user_id"
    t.integer "claimed_currency_id"
    t.integer "deposit_confirmation_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "currency_id_external_key"
    t.boolean "active", default: true
    t.index ["claimed_currency_id"], name: "index_attempted_linkages_on_claimed_currency_id"
    t.index ["user_id"], name: "index_attempted_linkages_on_user_id"
  end

  create_table "attempted_reallocations", force: :cascade do |t|
    t.integer "user_id"
    t.integer "claimed_currency_id"
    t.boolean "active", default: true
    t.string "username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["claimed_currency_id"], name: "index_attempted_reallocations_on_claimed_currency_id"
    t.index ["user_id"], name: "index_attempted_reallocations_on_user_id"
  end

  create_table "claimed_currencies", force: :cascade do |t|
    t.integer "user_id"
    t.integer "currency_id_external_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "product_id_external_key"
    t.integer "private_currency_holding_id_external_key"
    t.string "currency_name"
    t.string "currency_icon_url"
    t.integer "user_id_external_key"
    t.index ["currency_id_external_key"], name: "index_claimed_currencies_on_currency_id_external_key", unique: true
    t.index ["user_id"], name: "index_claimed_currencies_on_user_id"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider"
    t.string "uid"
    t.string "username"
    t.boolean "active", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  create_table "whitelisted_jwts", force: :cascade do |t|
    t.string "jti", null: false
    t.string "aud"
    t.datetime "exp", null: false
    t.integer "user_id", null: false
    t.index ["jti"], name: "index_whitelisted_jwts_on_jti", unique: true
    t.index ["user_id"], name: "index_whitelisted_jwts_on_user_id"
  end

end
