class AddRawAttributeToRecipeIngredient < ActiveRecord::Migration
  def self.up
    add_column :recipe_ingredients, :raw, :string
  end

  def self.down
    remove_column :recipe_ingredients, :raw
  end
end
