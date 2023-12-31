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

ActiveRecord::Schema[7.0].define(version: 2023_10_22_133433) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "bookmarks", force: :cascade do |t|
    t.bigint "kol_profile_id", null: false
    t.bigint "job_id", null: false
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_bookmarks_on_job_id"
    t.index ["kol_profile_id"], name: "index_bookmarks_on_kol_profile_id"
  end

  create_table "bussinesses", force: :cascade do |t|
    t.string "type_profile", default: "personal", null: false
    t.text "overview", default: "Welcome to our company profile! At XYZ Tech Solutions, we're not just about technology; we're about creating a better future. As a leading innovator in the field of Information Technology and Software, we've been driving progress and delivering exceptional technology solutions for over a decade.", null: false
    t.bigint "profile_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_bussinesses_on_profile_id"
  end

  create_table "emojis", force: :cascade do |t|
    t.string "status", null: false
    t.string "emojiable_type", null: false
    t.bigint "emojiable_id", null: false
    t.bigint "profile_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["emojiable_type", "emojiable_id"], name: "index_emojis_on_emojiable"
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

  create_table "google_integrates", force: :cascade do |t|
    t.bigint "profile_id", null: false
    t.string "gmail"
    t.string "refresh_token"
    t.string "access_token"
    t.string "code_authorization"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_google_integrates_on_profile_id"
  end

  create_table "industries", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "industry_associations", force: :cascade do |t|
    t.bigint "industry_id", null: false
    t.string "insdustry_associationable_type", null: false
    t.bigint "insdustry_associationable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["industry_id"], name: "index_industry_associations_on_industry_id"
    t.index ["insdustry_associationable_type", "insdustry_associationable_id"], name: "index_industry_associations_on_insdustry_associationable"
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
    t.text "requirement", default: "Requirement content", null: false
    t.string "benefits", default: "", null: false
    t.string "time_work", default: "", null: false
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
    t.text "about_me", default: "About me default", null: false
    t.index ["profile_id"], name: "index_kol_profiles_on_profile_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "title", null: false
    t.text "description", null: false
    t.string "type_notice", default: "notification", null: false
    t.boolean "is_read", default: false, null: false
    t.bigint "sender_id", null: false
    t.bigint "receiver_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["receiver_id"], name: "index_notifications_on_receiver_id"
    t.index ["sender_id"], name: "index_notifications_on_sender_id"
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
    t.string "avatar_url"
    t.string "uid"
    t.string "provider"
    t.string "stripe_id", default: "none", null: false
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "reports", force: :cascade do |t|
    t.string "title", null: false
    t.text "description", null: false
    t.string "reportable_type", null: false
    t.bigint "reportable_id", null: false
    t.bigint "profile_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "pending"
    t.index ["profile_id"], name: "index_reports_on_profile_id"
    t.index ["reportable_type", "reportable_id"], name: "index_reports_on_reportable"
  end

  create_table "reviews", force: :cascade do |t|
    t.text "content"
    t.bigint "reviewer_id", null: false
    t.bigint "reviewed_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reviewed_id"], name: "index_reviews_on_reviewed_id"
    t.index ["reviewer_id"], name: "index_reviews_on_reviewer_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource"
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
    t.string "category", default: "personal", null: false
    t.string "google_event_id", default: "none", null: false
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
    t.string "provider"
    t.string "uid"
    t.string "status", default: "invalid", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "bookmarks", "jobs"
  add_foreign_key "bookmarks", "kol_profiles"
  add_foreign_key "bussinesses", "profiles"
  add_foreign_key "emojis", "profiles"
  add_foreign_key "followers", "profiles", column: "followed_id"
  add_foreign_key "followers", "profiles", column: "follower_id"
  add_foreign_key "google_integrates", "profiles"
  add_foreign_key "industry_associations", "industries"
  add_foreign_key "jobs", "profiles"
  add_foreign_key "kol_profiles", "profiles"
  add_foreign_key "notifications", "profiles", column: "receiver_id"
  add_foreign_key "notifications", "profiles", column: "sender_id"
  add_foreign_key "profiles", "users"
  add_foreign_key "reports", "profiles"
  add_foreign_key "reviews", "profiles", column: "reviewed_id"
  add_foreign_key "reviews", "profiles", column: "reviewer_id"
  add_foreign_key "tasks", "kol_profiles"
end
