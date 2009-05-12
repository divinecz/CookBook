class PagesController < ApplicationController

  before_filter :require_no_user, :only => :index
  
  def index
    @user = User.new :email => '@'
  end

  def parser
    @recipe_ingredients = RecipeIngredient.all.collect &:parse!
  end

end
