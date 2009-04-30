class AddNewVersionAndBasedOnAttributesToRecipes < ActiveRecord::Migration
  def self.up
    add_column :recipes, :next_version_id, :integer
    add_column :recipes, :based_on_id, :integer
    add_index :recipes, :next_version_id
    add_index :recipes, :based_on_id
  end

  def self.down
    remove_column :recipes, :next_version_id
    remove_column :recipes, :based_on_id
  end
end
