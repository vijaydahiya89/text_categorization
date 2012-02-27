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

ActiveRecord::Schema.define(:version => 20120223130735) do

  create_table "answers", :force => true do |t|
    t.string   "answer"
    t.integer  "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",      :default => "wrong"
  end

  create_table "images", :force => true do |t|
    t.string   "name"
    t.string   "path"
    t.integer  "question_id"
    t.integer  "answer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "passages", :force => true do |t|
    t.text     "passage"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "question_banks", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "questions", :force => true do |t|
    t.string   "question"
    t.string   "topic_id"
    t.string   "subtopic_id"
    t.string   "direction"
    t.string   "positive_id"
    t.string   "negative_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "difficulty_id"
    t.integer  "passage_id"
    t.string   "question_type"
    t.string   "ans_status",      :default => "no_ans"
    t.integer  "questionbank_id", :default => 0
  end

  create_table "subtopics", :force => true do |t|
    t.string   "subtopic"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "topic_id"
  end

  create_table "topics", :force => true do |t|
    t.string   "topic"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
