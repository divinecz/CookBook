class CreateRecipeCategory < ActiveRecord::Migration
    def self.up
      create_table :recipe_category do |t|
        t.integer :recipe_id,
        t_integer :category_id,
        t.timestamps
      end
    end

    def self.down
      drop_table :recipe_category
    end
  end
end
