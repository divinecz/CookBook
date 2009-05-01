class CreateRecipeCategory < ActiveRecord::Migration
  def self.up
    create_table :recipe_category, :options => 'DEFAULT CHARSET=UTF8' do |t|
      t.integer :recipe_id
      t.integer :category_id
      t.timestamps
    end
  end

  def self.down
    drop_table :recipe_category
  end
end
