class Ingredient < ActiveRecord::Base
  acts_as_nested_set
  
  has_many :recipe_ingredients, :dependent => :destroy
  has_many :recipes, :through => :recipe_ingredient
  has_many :user_ingredients, :dependent => :destroy
  belongs_to :ingredient_type
  
  validates_uniqueness_of :name
  
  after_create :create_user_ingredient
  
  def create_user_ingredient
    UserIngredient.create :name => name.chars.normalize(:kd).to_s.gsub(/[^\x00-\x7F]/, '').downcase, :ingredient_id => id
  end
  
  def to_s
    name
  end
end
