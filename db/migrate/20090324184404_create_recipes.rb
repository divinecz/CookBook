class CreateRecipes < ActiveRecord::Migration
  def self.up
    create_table :recipes do |t|
      t.string :name
      t.text :directions
      t.integer :course_id
      t.timestamps
    end
  end

  def self.down
    drop_table :recipes
  end
end
