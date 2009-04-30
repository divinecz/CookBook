class CookbooksController < ApplicationController
  
  layout 'recipes'
  
  before_filter :require_user

end
