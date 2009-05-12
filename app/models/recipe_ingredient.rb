class RecipeIngredient < ActiveRecord::Base
  belongs_to :recipe
  belongs_to :ingredient
  
  def parse!
    update_attributes Parser.decode(raw)
  end
end
