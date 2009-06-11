module RecipesHelper
  def servings_count(recipe)
    " na #{recipe.servings} #{pluralize3 recipe.servings, ['porci', 'porce', 'porcí']}" unless recipe.servings.nil?
  end
  
  def time(recipe)
    " na #{recipe.time} #{pluralize3 recipe.time, ['minutu', 'minuty', 'minut']}" unless recipe.time.nil?
  end
end
