class Recipe < ActiveRecord::Base
  belongs_to :user
  has_many :recipe_ingredients, :dependent => :destroy
  has_many :ingredients, :through => :recipe_ingredients
  has_many :favorite_recipes, :dependent => :destroy
  belongs_to :next_version, :class_name => "Recipe", :foreign_key => "next_version_id"
  belongs_to :based_on, :class_name => "Recipe", :foreign_key => "based_on_id"
  # belongs_to :course
  
  validates_presence_of :name, :raw_ingredients, :user_id
  
  after_save :parse_raw_ingredients
  
  alias :owner :user
  
  def self.popular_search(recipe, limit = 4)
    pop = scoped_by_next_version_id(nil).find(:all, :conditions => ['name like ?', "%#{recipe[:name].gsub(' ', '%')}%"], :include => :favorite_recipes).sort_by(&:popularity)
    pop[[-limit, -pop.size].max..-1].reverse
  end
  
  def self.new_search(recipe, limit = 4)
    scoped_by_next_version_id(nil).find :all, :conditions => ['name like ?', "%#{recipe[:name].gsub(' ', '%')}%"], :order => 'id DESC', :limit => limit
  end
  
  def self.search(recipe, limit = 8)
    find :all, :conditions => ['name like ?', "%#{recipe[:name].gsub(' ', '%')}%"], :include => :favorite_recipes, :order => 'favorite_recipes.id DESC', :limit => limit
  end
  
  def self.all_with_no_favorite
    all.select{ |recipe| recipe.favorite_recipes.empty? }
  end
  
  def self.popular_recipes(limit = 4)
    scoped_by_next_version_id(nil).find(:all).sort_by(&:popularity)[-limit..-1].try(:reverse)
  end
  
  def self.new_recipes(limit = 4)
    scoped_by_next_version_id(nil).find :all, :order => 'id DESC', :limit => limit
  end

  def popularity
    favorite_recipes.length
  end
  
  def directions_rows_count
    directions.split("\n").collect{ |row| (row.length/67.0+0.5).round }.sum rescue 0
  end
  
  def directions=(directions)
    write_attribute :directions, directions.split("\n").collect(&:strip).select{ |direction| direction.length > 1}.join("\n")
  end
  
  def raw_ingredients
    @raw_ingredients || recipe_ingredients.collect(&:raw).join("\n")
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
    self.name == other.name && self.directions.gsub("\r",'') == other.directions.gsub("\r",'') && self.raw_ingredients == other.raw_ingredients
  end
  
  def to_s
    "#{name} (#{owner})"
  end
end
