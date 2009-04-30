class CreateCookbooks < ActiveRecord::Migration
  def self.up
    create_table :favorite_recipes do |t|
      t.integer :user_id
      t.integer :recipe_id
      t.timestamps
    end
    
    add_index :favorite_recipes, [:user_id, :recipe_id], :unique => true
    add_index :favorite_recipes, :recipe_id
  end

  def self.down
    drop_table :favorite_recipes
  end
end
