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

ActiveRecord::Schema[7.1].define(version: 2024_01_01_000006) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "blacklists", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "phone", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "phone"], name: "index_blacklists_on_user_id_and_phone", unique: true
    t.index ["user_id"], name: "index_blacklists_on_user_id"
  end

  create_table "inbound_messages", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "network"
    t.string "source_addr"
    t.string "destination_addr"
    t.string "keyword"
    t.text "content"
    t.datetime "received_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_inbound_messages_on_user_id"
  end

  create_table "sms_campaigns", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "custom_id"
    t.string "source_addr"
    t.string "valid_for", default: "24:00"
    t.integer "datacoding", default: 0
    t.boolean "is_commercial", default: false
    t.string "iys_recipient_type"
    t.datetime "send_at"
    t.string "status", default: "pending"
    t.integer "total_messages", default: 0
    t.decimal "total_credits", precision: 10, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["custom_id"], name: "index_sms_campaigns_on_custom_id"
    t.index ["status"], name: "index_sms_campaigns_on_status"
    t.index ["user_id"], name: "index_sms_campaigns_on_user_id"
  end

  create_table "sms_headers", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sms_headers_on_user_id"
  end

  create_table "sms_messages", force: :cascade do |t|
    t.bigint "sms_campaign_id", null: false
    t.string "custom_id"
    t.string "dest", null: false
    t.text "msg", null: false
    t.integer "size", default: 1
    t.integer "international_multiplier", default: 1
    t.decimal "credits", precision: 10, scale: 2, default: "1.0"
    t.string "status", default: "SENDING"
    t.string "gsm_error"
    t.datetime "sent_at"
    t.datetime "done_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dest"], name: "index_sms_messages_on_dest"
    t.index ["sms_campaign_id"], name: "index_sms_messages_on_sms_campaign_id"
    t.index ["status"], name: "index_sms_messages_on_status"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.string "password_digest", null: false
    t.decimal "credits", precision: 10, scale: 2, default: "100.0"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "blacklists", "users"
  add_foreign_key "inbound_messages", "users"
  add_foreign_key "sms_campaigns", "users"
  add_foreign_key "sms_headers", "users"
  add_foreign_key "sms_messages", "sms_campaigns"
end
