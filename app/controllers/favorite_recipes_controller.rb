class FavoriteRecipesController < ApplicationController
  
  layout 'recipes'
  
  def create
    favorite_recipe = current_user.favorite_recipes.create :recipe_id => params[:recipe_id]
    @recipe = favorite_recipe.recipe
  end
  
  def destroy
    favorite_recipe = current_user.favorite_recipes.find params[:id]
    @recipe = favorite_recipe.recipe
    favorite_recipe.destroy
    render :create
  end
end
