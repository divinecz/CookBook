class FavoriteRecipe < ActiveRecord::Base
  belongs_to :user
  belongs_to :recipe
  
  validates_presence_of :user_id, :recipe_id
end
