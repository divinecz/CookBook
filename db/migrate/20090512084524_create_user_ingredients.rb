class CreateUserIngredients < ActiveRecord::Migration
  def self.up
    create_table :user_ingredients do |t|
      t.string :name, :null => false
      t.integer :used_count, :default => 0
      t.integer :ingredient_id
      t.timestamps
    end
    
    %w(ingredience ovoce zelenina těstoviny maso koření paprika jogurt majonéza rýže olej pepř sůl voda kečup zázvor slanina cibule vejce šunka pečivo eidam sardinka ryby citrón hořčice česnek niva cottage chléb).each do |ingredient|
      Ingredient.create :name => ingredient
    end
  end

  def self.down
    Ingredient.all.each &:destroy
    drop_table :user_ingredients
  end
end
