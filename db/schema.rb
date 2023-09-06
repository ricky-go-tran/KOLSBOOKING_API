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

ActiveRecord::Schema[7.0].define(version: 2023_09_06_081418) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookmarks", force: :cascade do |t|
    t.bigint "kol_profile_id", null: false
    t.bigint "job_id", null: false
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_bookmarks_on_job_id"
    t.index ["kol_profile_id"], name: "index_bookmarks_on_kol_profile_id"
  end

  create_table "emojis", force: :cascade do |t|
    t.string "type", null: false
    t.bigint "objective_id", null: false
    t.bigint "profile_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["objective_id"], name: "index_emojis_on_objective_id"
    t.index ["profile_id"], name: "index_emojis_on_profile_id"
  end

  create_table "followers", force: :cascade do |t|
    t.bigint "follower_id", null: false
    t.bigint "followed_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["followed_id"], name: "index_followers_on_followed_id"
    t.index ["follower_id"], name: "index_followers_on_follower_id"
  end

  create_table "jobs", force: :cascade do |t|
    t.bigint "profile_id", null: false
    t.bigserial "kol_id", null: false
    t.string "title", null: false
    t.text "description"
    t.float "price", null: false
    t.string "status", default: "post", null: false
    t.string "stripe_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_jobs_on_profile_id"
  end

  create_table "kol_profiles", force: :cascade do |t|
    t.string "tiktok_path"
    t.string "youtube_path"
    t.string "facebook_path"
    t.string "instagram_path"
    t.string "stripe_public_key"
    t.string "stripe_private_key"
    t.bigint "profile_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_kol_profiles_on_profile_id"
  end

  create_table "objectives", force: :cascade do |t|
    t.string "type_object"
    t.bigserial "object_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "profiles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "fullname", null: false
    t.date "birthday"
    t.string "phone"
    t.text "address"
    t.string "status", default: "valid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "reports", force: :cascade do |t|
    t.string "title", null: false
    t.text "description", null: false
    t.bigint "objective_id", null: false
    t.bigint "profile_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["objective_id"], name: "index_reports_on_objective_id"
    t.index ["profile_id"], name: "index_reports_on_profile_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.bigint "kol_profile_id", null: false
    t.string "title", null: false
    t.datetime "start_time", null: false
    t.datetime "end_time", null: false
    t.string "status", default: "planning", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["kol_profile_id"], name: "index_tasks_on_kol_profile_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "jti", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "bookmarks", "jobs"
  add_foreign_key "bookmarks", "kol_profiles"
  add_foreign_key "emojis", "objectives"
  add_foreign_key "emojis", "profiles"
  add_foreign_key "followers", "profiles", column: "followed_id"
  add_foreign_key "followers", "profiles", column: "follower_id"
  add_foreign_key "jobs", "profiles"
  add_foreign_key "kol_profiles", "profiles"
  add_foreign_key "profiles", "users"
  add_foreign_key "reports", "objectives"
  add_foreign_key "reports", "profiles"
  add_foreign_key "tasks", "kol_profiles"
end
