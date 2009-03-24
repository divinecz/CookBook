class IngredientIngredientType < ActiveRecord::Migration
  def self.up
    create_table :ingredient_ingredient_type do |t|
      t.integer :ingredient_id,
      t.integer :category_id,
    end
  end

  def self.down
    drop_table :ingredient_ingredient_type
  end
end
