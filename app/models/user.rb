class User < ActiveRecord::Base
  has_many :favorite_recipes, :dependent => :destroy
  has_many :recipes, :through => :favorite_recipes
  acts_as_authentic
  # User.logged_in
  # User.logged_out

  before_validation :fill_empty_columns

  def my_recipes(limit = 8)
    FavoriteRecipe.scoped_by_user_id(self).find(:all, :order => 'id DESC', :limit => limit, :include => :recipe).collect(&:recipe)
  end

  def favorite_recipe?(recipe)
    favorite_recipes.find_by_recipe_id(recipe)
  end

  def fill_empty_columns
    self.password ||= generate_password
    self.password_confirmation ||= self.password
    self.login ||= generate_login
  end

  def generate_password
    dict = ("a".."z").to_a + ("0".."9").to_a
    password = ""
    
    6.times { password << dict[rand(dict.size)] }
    password
  end

  def generate_login
    email.split('@').first # TODO: Cekovat unikatnost
  end

  def to_s
    login
  end
end