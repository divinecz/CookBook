class Ingredient < ActiveRecord::Base
  has_many :recipe_ingredients
  has_many :recipes, :through => :recipe_ingredient
  belongs_to :ingredient_type
end
