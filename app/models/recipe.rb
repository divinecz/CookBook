class Recipe < ActiveRecord::Base
  belongs_to :user
  has_many :recipe_ingredients, :dependent => :destroy, :order => 'id'
  has_many :ingredients, :through => :recipe_ingredients
  has_many :favorite_recipes, :dependent => :destroy
  belongs_to :next_version, :class_name => "Recipe", :foreign_key => "next_version_id"
  belongs_to :based_on, :class_name => "Recipe", :foreign_key => "based_on_id"
  # belongs_to :course
  
  validates_presence_of :name, :raw_ingredients, :user_id
  
  after_save :parse_raw_ingredients
  
  alias :owner :user
  
  def my_favorite?
    @my_favorite ||= UserSession.find.user.favorite_recipes.find_by_recipe_id(self)
  end
  
  def self.popular_search(recipe, limit = 8)
    with_scope :find => { :conditions => ['name like ?', "%#{recipe[:name].gsub(' ', '%')}%"] } do
      popular_recipes(limit)
    end
  end
  
  # def self.new_search(recipe, limit = 4)
  #   with_scope :find => { :conditions => ['name like ?', "%#{recipe[:name].gsub(' ', '%')}%"] } do
  #     new_recipes(limit)
  #   end
  # end
  
  def self.search(recipe, limit = 12)
    find :all, :conditions => ['name like ?', "%#{recipe[:name].gsub(' ', '%')}%"], :include => :favorite_recipes, :order => 'favorite_recipes.id DESC', :limit => limit
  end
  
  def self.popular_recipes(limit = 8)
    find(:all, :conditions => ["favorite_recipes_count > 0"], :order => 'favorite_recipes_count DESC, id DESC', :limit => limit) # TODO: id DESC se muze smazat, pokud bude zbytecne zdrzovat
  end
  
  # def self.new_recipes(limit = 4)
  #   scoped_by_next_version_id(nil).find :all, :order => 'created_at DESC', :limit => limit
  # end

  def popularity
    favorite_recipes.length
  end
  
  def directions
    read_attribute(:directions) + "\n" rescue ""
  end
  
  def directions_rows_count
    directions.split("\n").collect{ |row| (row.length/67.0+0.5).round }.sum rescue 0
  end
  
  def directions=(directions)
    write_attribute :directions, directions.split("\n").collect(&:strip).select{ |direction| direction.length > 1}.join("\n")
  end
  
  def raw_ingredients
    (@raw_ingredients || recipe_ingredients.collect(&:raw).join("\n")) + "\n" rescue ""
  end
  
  def raw_ingredients=(raw_ingredients)
    @raw_ingredients = raw_ingredients.split("\n").collect(&:strip).select{ |raw_ingredient| raw_ingredient =~ /\w{3}/ }.join("\n")
  end
  
  def parse_raw_ingredients
    recipe_ingredients.each(&:destroy) # TODO: Sem do budoucna mozna nejaka optimalizace, aby se vzdy vsechno nepremazavalo
    
    raw_ingredients.split("\n").each do |raw_ingredient|
      recipe_ingredients.create(:raw => raw_ingredient)
    end unless raw_ingredients.blank?
  end
  
  def ==(other)
    self.time == other.time && self.servings == other.servings && self.name == other.name && self.directions.gsub("\r",'') == other.directions.gsub("\r",'') && self.raw_ingredients == other.raw_ingredients
  end
  
  def to_s
    name
  end
  
  def to_param
    [id, name.remove_diacritic.downcase.gsub(/[^a-z0-9 ]/, '').gsub('  ',' ').gsub(' ', '-')].join('-')
  end
end
