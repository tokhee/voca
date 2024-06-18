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

ActiveRecord::Schema[7.1].define(version: 2024_06_13_125150) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "questions", force: :cascade do |t|
    t.string "title"
    t.bigint "quiz_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "word_id", null: false
    t.string "user_answer"
    t.boolean "answered", default: false
    t.index ["quiz_id"], name: "index_questions_on_quiz_id"
    t.index ["word_id"], name: "index_questions_on_word_id"
  end

  create_table "quizzes", force: :cascade do |t|
    t.string "title"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "score", default: 0
    t.index ["user_id"], name: "index_quizzes_on_user_id"
  end

  create_table "similars", force: :cascade do |t|
    t.bigint "word_id", null: false
    t.string "similar"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["word_id"], name: "index_similars_on_word_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.bigint "word_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_tags_on_user_id"
    t.index ["word_id"], name: "index_tags_on_word_id"
  end

  create_table "tags_words", id: false, force: :cascade do |t|
    t.bigint "word_id", null: false
    t.bigint "tag_id", null: false
    t.index ["tag_id"], name: "index_tags_words_on_tag_id"
    t.index ["word_id"], name: "index_tags_words_on_word_id"
  end

  create_table "user_answers", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "question_id", null: false
    t.string "answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_user_answers_on_question_id"
    t.index ["user_id"], name: "index_user_answers_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email", null: false
    t.string "password_digest"
    t.integer "highest_rate"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "score"
    t.float "correct_rate", default: 0.0
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "words", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title", null: false
    t.text "mean", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "similar_id"
    t.bigint "tag_id"
    t.string "correct_answer"
    t.index ["similar_id"], name: "index_words_on_similar_id"
    t.index ["tag_id"], name: "index_words_on_tag_id"
    t.index ["user_id"], name: "index_words_on_user_id"
  end

  add_foreign_key "questions", "quizzes"
  add_foreign_key "questions", "words"
  add_foreign_key "quizzes", "users"
  add_foreign_key "similars", "words"
  add_foreign_key "tags", "users"
  add_foreign_key "tags", "words"
  add_foreign_key "user_answers", "questions"
  add_foreign_key "user_answers", "users"
  add_foreign_key "words", "similars"
  add_foreign_key "words", "tags"
  add_foreign_key "words", "users"
end
