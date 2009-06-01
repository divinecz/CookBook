class Ingredient < ActiveRecord::Base
  acts_as_nested_set
  
  has_many :recipe_ingredients, :dependent => :destroy
  has_many :recipes, :through => :recipe_ingredient
  has_many :user_ingredients, :dependent => :destroy
  belongs_to :ingredient_type
  
  validates_uniqueness_of :name
  
  after_create :create_user_ingredient
  
  def create_user_ingredient
    UserIngredient.create :name => Iconv.new('ascii//translit', 'utf-8').iconv(name).downcase.gsub(/[^0-9a-z-]/, ''), :ingredient_id => id
  end
  
  def to_s
    name
  end
end
