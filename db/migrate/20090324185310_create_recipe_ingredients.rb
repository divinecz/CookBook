class CreateRecipeIngredients < ActiveRecord::Migration
  def self.up
    create_table :recipe_ingredients, :options => 'DEFAULT CHARSET=UTF8' do |t|
      t.decimal :amount
      t.string :units # TODO: do vlastni tabulky!
      t.integer :recipe_id
      t.integer :ingredient_id
      t.timestamps
    end
  end

  def self.down
    drop_table :recipe_ingredients
  end
end
