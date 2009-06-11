ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'pages'
  map.login '/login', :controller => 'user_sessions', :action => 'new'
  map.logout '/logout', :controller => 'user_sessions', :action => 'destroy'
  map.parser '/parser', :controller => 'pages', :action => 'parser'
  
  map.resources :users
  map.resource :user_session
  map.resource :cookbook
  map.resources :recipes, :collection => { :recipe_search => :post, :open => :post }, :member => { :send_form => :get, :send => :post }
  map.resources :favorite_recipes
end