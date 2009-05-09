class FavoriteRecipesController < ApplicationController
  
  layout 'recipes'
  
  def create
    @favorite_recipe = current_user.favorite_recipes.create params[:favorite_recipe]
    @recipe = @favorite_recipe.recipe
    
    respond_to do |wants|
      wants.html { redirect_to @recipe }
      wants.js { render :create }
    end
  end
  
  def destroy
    favorite_recipe = current_user.favorite_recipes.find params[:id]
    @recipe = favorite_recipe.recipe
    favorite_recipe.destroy
    
    respond_to do |wants|
      wants.html { redirect_to @recipe }
      wants.js { render :create }
    end
  end
end
