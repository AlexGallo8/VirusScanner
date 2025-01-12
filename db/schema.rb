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

ActiveRecord::Schema[7.1].define(version: 2025_01_12_120231) do
  create_table "comments", force: :cascade do |t|
    t.text "content"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "scans", force: :cascade do |t|
    t.string "file_name"
    t.string "file_type"
    t.string "hashcode"
    t.integer "file_size"
    t.datetime "upload_date"
    t.integer "vote_up", default: 0
    t.integer "vote_down", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "scan_result"
    t.text "file_data"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "auth_provider"
    t.string "auth0_uid"
    t.index ["auth0_uid"], name: "index_users_on_auth0_uid", unique: true
  end

  add_foreign_key "comments", "users"
end
