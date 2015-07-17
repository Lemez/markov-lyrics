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

ActiveRecord::Schema.define(version: 20150717092827) do

  create_table "lines", force: :cascade do |t|
    t.integer "line_number"
    t.integer "number_of_words"
    t.integer "number_of_tokens"
    t.integer "number_of_syllables"
    t.string  "last_word_rhyme"
    t.string  "last_word_pos"
    t.string  "line"
  end

  create_table "songs", force: :cascade do |t|
    t.integer  "number_of_shares"
    t.datetime "created_at"
    t.integer  "number_of_stanzas"
    t.string   "created_by"
  end

  create_table "stanzas", force: :cascade do |t|
    t.string  "type"
    t.integer "number_of_lines"
    t.string  "pattern"
    t.integer "position_in_song"
  end

  create_table "tokens", force: :cascade do |t|
    t.string  "token"
    t.string  "pos"
    t.integer "position_in_word"
  end

  create_table "words", force: :cascade do |t|
    t.integer "position_in_line"
    t.string  "rhyme"
    t.string  "meaning"
    t.string  "lemma"
    t.string  "word"
    t.integer "number_of_tokens"
  end

end