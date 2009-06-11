module RecipesHelper
  def servings_count(recipe)
    " na #{recipe.servings} porce" unless recipe.servings.nil?
  end
  
  def time(recipe)
    " (#{recipe.time} minut)" unless recipe.time.nil?
  end
end
