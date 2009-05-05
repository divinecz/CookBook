class RecipesController < ApplicationController
  
  before_filter :require_user#, :except => :show

  def recipe_search
    @recipes = current_user.recipes.search params[:recipe]
    @new_recipes = Recipe.new_search(params[:recipe], (12-@recipes.length)/1.7)
    @popular_recipes = Recipe.popular_search(params[:recipe], (12-@recipes.length)/1.7)
  end
  
  def index
    @recipes = current_user.my_recipes
    if @recipes.empty?
      @recipe = Recipe.new
      @focus_e = 0
      @focus_f = 1
      render :new
    else
      @recipe = @recipes.first
      @focus_e = 0
      render :show
    end
  end
  
  def new
    @recipe = Recipe.new
    # @focus_f = 1
    # @focus_e = 0
  end
  
  def update
    old_recipe = current_user.recipes.find params[:id]
    new_recipe = Recipe.new params[:recipe].merge(:user_id => current_user.id)
    
    if old_recipe == new_recipe
      @recipe = old_recipe
    elsif new_recipe.valid?
      if old_recipe.owner == current_user
        new_recipe.created_at = old_recipe.created_at
        new_recipe.save
        old_recipe.next_version = new_recipe
        old_recipe.save
      else
        new_recipe.based_on = old_recipe
        new_recipe.save
      end
      current_user.favorite_recipes.find_by_recipe_id(old_recipe).destroy
      current_user.recipes << new_recipe
      @recipe = new_recipe
    else
      old_recipe.attributes = params[:recipe]
      @recipe = old_recipe
      render :edit
    end
  end
  
  def edit
    @recipe = Recipe.find params[:id]
  end
  
  def show
    @recipe = Recipe.find params[:id]
  end
  
  def create
    @recipe = Recipe.new params[:recipe].merge(:user_id => current_user.id)
    if @recipe.save
      current_user.recipes << @recipe
    else
      render :new
    end
  end
end 