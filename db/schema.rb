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

ActiveRecord::Schema[7.1].define(version: 2025_02_11_235739) do
  create_table "comment_votes", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "comment_id", null: false
    t.string "vote_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["comment_id"], name: "index_comment_votes_on_comment_id"
    t.index ["user_id", "comment_id"], name: "index_comment_votes_on_user_id_and_comment_id", unique: true
    t.index ["user_id"], name: "index_comment_votes_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text "content"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "scan_id"
    t.integer "likes_count", default: 0
    t.integer "dislikes_count", default: 0
    t.index ["scan_id"], name: "index_comments_on_scan_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "scan_users", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "scan_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["scan_id"], name: "index_scan_users_on_scan_id"
    t.index ["user_id"], name: "index_scan_users_on_user_id"
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
    t.integer "user_id"
    t.string "vt_id"
    t.index ["user_id"], name: "index_scans_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "auth_provider"
    t.string "auth0_uid"
    t.string "username"
    t.string "password_reset_token"
    t.string "remember_token"
    t.datetime "remember_token_expires_at"
    t.index ["auth0_uid"], name: "index_users_on_auth0_uid", unique: true
    t.index ["remember_token"], name: "index_users_on_remember_token"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "votes", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "scan_id", null: false
    t.string "vote_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["scan_id"], name: "index_votes_on_scan_id"
    t.index ["user_id", "scan_id"], name: "index_votes_on_user_id_and_scan_id", unique: true
    t.index ["user_id"], name: "index_votes_on_user_id"
  end

  add_foreign_key "comment_votes", "comments"
  add_foreign_key "comment_votes", "users"
  add_foreign_key "comments", "users"
  add_foreign_key "scan_users", "scans"
  add_foreign_key "scan_users", "users"
  add_foreign_key "votes", "scans"
  add_foreign_key "votes", "users"
end
