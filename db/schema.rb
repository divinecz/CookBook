# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090324200705) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "courses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ingredient_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ingredients", :force => true do |t|
    t.string   "name"
    t.integer  "unit_carbs",         :limit => 10, :precision => 10, :scale => 0
    t.integer  "unit_protein",       :limit => 10, :precision => 10, :scale => 0
    t.integer  "unit_fat",           :limit => 10, :precision => 10, :scale => 0
    t.integer  "unit_sugar",         :limit => 10, :precision => 10, :scale => 0
    t.integer  "unit_vitamin_a",     :limit => 10, :precision => 10, :scale => 0
    t.integer  "unit_vitamin_b6",    :limit => 10, :precision => 10, :scale => 0
    t.integer  "unit_vitamin_c",     :limit => 10, :precision => 10, :scale => 0
    t.integer  "unit_calcium",       :limit => 10, :precision => 10, :scale => 0
    t.integer  "ingredient_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recipe_category", :force => true do |t|
    t.integer  "recipe_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recipe_ingredients", :force => true do |t|
    t.integer  "amount",        :limit => 10, :precision => 10, :scale => 0
    t.string   "units"
    t.integer  "recipe_id"
    t.integer  "ingredient_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recipes", :force => true do |t|
    t.string   "name"
    t.text     "directions"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.integer  "login_count"
    t.datetime "last_request_at"
    t.datetime "last_login_at"
    t.datetime "current_login_at"
    t.string   "last_login_ip"
    t.string   "current_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
