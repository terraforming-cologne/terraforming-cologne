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

ActiveRecord::Schema[8.0].define(version: 2025_10_23_183828) do
  create_table "attendances", force: :cascade do |t|
    t.integer "participation_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "round_id", null: false
    t.index ["participation_id"], name: "index_attendances_on_participation_id", unique: true
    t.index ["round_id"], name: "index_attendances_on_round_id"
  end

  create_table "games", force: :cascade do |t|
    t.integer "table_id", null: false
    t.integer "round_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["round_id"], name: "index_games_on_round_id"
    t.index ["table_id"], name: "index_games_on_table_id"
  end

  create_table "participations", force: :cascade do |t|
    t.boolean "brings_basegame_english", default: false, null: false
    t.boolean "brings_prelude_english", default: false, null: false
    t.boolean "brings_hellas_and_elysium", default: false, null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "paid", default: false, null: false
    t.boolean "brings_basegame_german", default: false, null: false
    t.boolean "brings_prelude_german", default: false, null: false
    t.text "comment"
    t.integer "tournament_id", null: false
    t.integer "rank"
    t.index ["tournament_id", "user_id"], name: "index_participations_on_tournament_id_and_user_id", unique: true
    t.index ["tournament_id"], name: "index_participations_on_tournament_id"
    t.index ["user_id"], name: "index_participations_on_user_id"
  end

  create_table "results", force: :cascade do |t|
    t.integer "generations", null: false
    t.integer "game_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_results_on_game_id", unique: true
  end

  create_table "rooms", force: :cascade do |t|
    t.integer "number", null: false
    t.integer "tournament_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tournament_id"], name: "index_rooms_on_tournament_id"
  end

  create_table "rounds", force: :cascade do |t|
    t.integer "number", null: false
    t.string "board", null: false
    t.integer "tournament_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.time "start_time", null: false
    t.index ["tournament_id"], name: "index_rounds_on_tournament_id"
  end

  create_table "scores", force: :cascade do |t|
    t.string "corporation", null: false
    t.integer "points", null: false
    t.integer "rank", null: false
    t.integer "seat_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["seat_id"], name: "index_scores_on_seat_id", unique: true
  end

  create_table "seats", force: :cascade do |t|
    t.integer "number", null: false
    t.integer "game_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "attendance_id", null: false
    t.index ["attendance_id"], name: "index_seats_on_attendance_id"
    t.index ["game_id"], name: "index_seats_on_game_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "tables", force: :cascade do |t|
    t.integer "number", null: false
    t.integer "room_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_tables_on_room_id"
  end

  create_table "tournaments", force: :cascade do |t|
    t.string "name", null: false
    t.date "date", null: false
    t.integer "max_participations", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "current_round_number"
    t.index ["date"], name: "index_tournaments_on_date", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.boolean "admin", default: false, null: false
    t.boolean "deactivated", default: false, null: false
    t.string "locale", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
    t.index ["name"], name: "index_users_on_name", unique: true
  end

  add_foreign_key "attendances", "participations"
  add_foreign_key "attendances", "rounds"
  add_foreign_key "games", "rounds"
  add_foreign_key "games", "tables"
  add_foreign_key "participations", "tournaments"
  add_foreign_key "participations", "users"
  add_foreign_key "results", "games"
  add_foreign_key "rooms", "tournaments"
  add_foreign_key "rounds", "tournaments"
  add_foreign_key "scores", "seats"
  add_foreign_key "seats", "attendances"
  add_foreign_key "seats", "games"
  add_foreign_key "sessions", "users"
  add_foreign_key "tables", "rooms"
end
