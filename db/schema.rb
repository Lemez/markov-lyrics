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

ActiveRecord::Schema.define(version: 20150730135536) do

  create_table "choruses", force: :cascade do |t|
    t.string  "pattern"
    t.integer "number_lines"
    t.integer "song_id"
  end

  create_table "lines", force: :cascade do |t|
    t.integer "line_number"
    t.integer "number_of_words"
    t.integer "number_of_tokens"
    t.integer "number_of_syllables"
    t.string  "last_word_rhyme"
    t.string  "last_word_pos"
    t.string  "line"
    t.boolean "has_rhyme"
    t.integer "verse_id"
    t.integer "chorus_id"
  end

  create_table "songs", force: :cascade do |t|
    t.integer  "number_of_shares"
    t.datetime "created_at"
    t.string   "created_by"
    t.string   "pattern"
    t.string   "song_pattern"
    t.integer  "number_of_verses"
    t.integer  "number_lines"
  end

  create_table "tokens", force: :cascade do |t|
    t.string  "token"
    t.string  "pos"
    t.integer "position_in_word"
    t.integer "word_id"
  end

  create_table "verses", force: :cascade do |t|
    t.integer "position"
    t.string  "pattern"
    t.integer "song_id"
    t.integer "number_lines"
  end

  create_table "words", force: :cascade do |t|
    t.integer "position_in_line"
    t.string  "rhyme"
    t.string  "meaning"
    t.string  "lemma"
    t.string  "word"
    t.integer "number_of_tokens"
    t.integer "line_id"
  end

end
