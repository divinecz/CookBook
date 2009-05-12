class Parser
  class << self
  
    def decode(str)
      @raw = str.chars.normalize(:kd).to_s.gsub(/[^\x00-\x7F]/, '')
      return { :ingredient_id => decode_ingredient, :units => decode_units, :amount => decode_amount }
    end
  
    def decode_ingredient
      @raw.split(/[^\w]/).each_with_index do |word, i|
        if !(ingredients = find(word)).empty?
          if !(ingredients2 = find(@raw.split(/[^\w]/)[i+1])).empty?
            return intersection.sort_by{ |ingredient| ingredient.name.length }.first.ingredient_id unless (intersection = ingredients & ingredients2).empty?
          end
          return ingredients.sort_by{ |ingredient| ingredient.name.length }.first.ingredient_id
        end
      end
      nil
    end
  
    def decode_units
      nil
    end
  
    def decode_amount
      @raw.scan(/\d+/).first
    end
  
    def find(word)
      return [] if word.nil? || word.length < 3
      UserIngredient.find(:all, :conditions => ["name RLIKE ?", "^"+word[0..-2]+".?$"]) # Odriznem si posledni pismenko [paprika, papriky] => paprik
    end
  end
end