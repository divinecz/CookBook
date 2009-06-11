class AddServingsAndTimeToRecipes < ActiveRecord::Migration
  def self.up
    add_column :recipes, :servings, :integer
    add_column :recipes, :time, :integer
  end

  def self.down
    remove_column :recipes, :servings
    remove_column :recipes, :time
  end
end
