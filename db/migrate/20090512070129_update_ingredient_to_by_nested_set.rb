class UpdateIngredientToByNestedSet < ActiveRecord::Migration
  def self.up
    add_column :ingredients, :parent_id, :integer
    add_column :ingredients, :lft, :integer
    add_column :ingredients, :rgt, :integer
    
    add_index :ingredients, :parent_id
    add_index :ingredients, :lft, :unique => true
    add_index :ingredients, :rgt, :unique => true
    
    Ingredient.reset_column_information
  end

  def self.down
    remove_column :ingredients, :parent_id
    remove_column :ingredients, :lft
    remove_column :ingredients, :rgt
  end
end
