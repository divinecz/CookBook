class AddFavoriteRecipesCountToRecipes < ActiveRecord::Migration
  def self.up
    add_column :recipes, :favorite_recipes_count, :integer, :default => 0
    
    Recipe.reset_column_information
    Recipe.all.each do |r|
      Recipe.update_counters r.id, :favorite_recipes_count => r.favorite_recipes.count
    end
  end

  def self.down
    remove_column :recipes, :favorite_recipes_count
  end
end
