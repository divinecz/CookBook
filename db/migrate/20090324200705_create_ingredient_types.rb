class CreateIngredientTypes < ActiveRecord::Migration
  def self.up
    create_table :ingredient_types, :options => 'DEFAULT CHARSET=UTF8' do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :ingredient_types
  end
end
