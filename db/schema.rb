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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111126084410) do

  create_table "boards", :force => true do |t|
    t.string   "name"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "boards", ["name"], :name => "index_boards_on_name"

  create_table "texts", :force => true do |t|
    t.integer  "board_id"
    t.integer  "row"
    t.integer  "left"
    t.integer  "right"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "texts", ["board_id", "row", "left", "updated_at"], :name => "index_texts_on_board_id_and_row_and_left_and_updated_at"
  add_index "texts", ["board_id", "row", "left"], :name => "index_texts_on_board_id_and_row_and_left"
  add_index "texts", ["board_id", "row", "right", "updated_at"], :name => "index_texts_on_board_id_and_row_and_right_and_updated_at"
  add_index "texts", ["board_id", "row", "right"], :name => "index_texts_on_board_id_and_row_and_right"
  add_index "texts", ["board_id", "row"], :name => "index_texts_on_board_id_and_row"

end
