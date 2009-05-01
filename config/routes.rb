ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'pages'
  map.login '/login', :controller => 'user_sessions', :action => 'new'
  
  map.resources :users
  map.resource :user_session
  map.resource :cookbook
  map.resources :recipes, :collection => { :recipe_search => :post }
  map.resources :favorite_recipes
end