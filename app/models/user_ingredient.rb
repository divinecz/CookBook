class UserIngredient < ActiveRecord::Base
  belongs_to :ingredient
  
  validates_presence_of :name, :ingredient_id
end
