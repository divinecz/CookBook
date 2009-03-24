class CreateIngredients < ActiveRecord::Migration
  def self.up
    create_table :ingredients do |t|
      t.string :name
      t.decimal :unit_carbs
      t.decimal :unit_protein
      t.decimal :unit_fat
      t.decimal :unit_sugar
      t.decimal :unit_vitamin_a
      t.decimal :unit_vitamin_b6
      t.decimal :unit_vitamin_c
      t.decimal :unit_calcium
      t.integer :ingredient_type_id
      t.timestamps
    end
  end

  def self.down
    drop_table :ingredients
  end
end
