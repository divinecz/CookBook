class RecipesController < ApplicationController
  
  before_filter :require_user#, :except => :show

  def recipe_search
    @recipes = current_user.recipes.search params[:recipe]
    @new_recipes = Recipe.new_search(params[:recipe], (12-@recipes.length)/1.7)
    @popular_recipes = Recipe.popular_search(params[:recipe], (12-@recipes.length)/1.7)
  end
  
  def index
    load_recipes
    if @recipes.empty?
      new
      render :new
    else
      @recipe = @recipes.first
      show
      render :show
    end
  end
  
  def new
    @recipe = Recipe.new
    @last_recipe = FavoriteRecipe.scoped_by_user_id(current_user.id).last.try(:recipe)
    respond_to do |wants|
      wants.html { 
        load_recipes
        @focus_f = 1
        @focus_e = 0 }
      wants.js
    end
  end
  
  def update
    old_recipe = current_user.recipes.find params[:id]
    new_recipe = Recipe.new params[:recipe].merge(:user_id => current_user.id)
    
    if old_recipe == new_recipe
      @recipe = old_recipe
      
      respond_to do |wants|
        wants.html { load_recipes ; redirect_to recipe_path(@recipe) }
        wants.js
      end
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
      
      respond_to do |wants|
        wants.html { load_recipes ; redirect_to recipe_path(@recipe) }
        wants.js
      end
    else
      old_recipe.attributes = params[:recipe]
      @recipe = old_recipe
      render :edit
    end
  end
  
  def edit
    @recipe = Recipe.find params[:id]
    respond_to do |wants|
      wants.html { load_recipes }
      wants.js
    end
  end
  
  def show
    @recipe ||= Recipe.find params[:id]
    respond_to do |wants|
      wants.html {
        load_recipes
        @focus_e = 0 }
      wants.js
    end
  end
  
  def create
    @recipe = Recipe.new params[:recipe].merge(:user_id => current_user.id)
    if @recipe.save
      current_user.recipes << @recipe
      
      respond_to do |wants|
        wants.html { redirect_to @recipe }
        wants.js
      end
    else
      respond_to do |wants|
        wants.html { load_recipes }
        wants.js
      end
      
      render :new
    end
  end

  private
  
  def load_recipes
    @recipes ||= current_user.my_recipes
  end
end 