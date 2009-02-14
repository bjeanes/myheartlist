ActionController::Routing::Routes.draw do |map|

  map.signup 'signup', :controller => 'users', :action => 'new'
  map.logout 'logout', :controller => 'sessions', :action => 'destroy'
  map.login 'login', :controller => 'sessions', :action => 'new'
  map.resources :sessions

  map.resources :hearts, :only=>[:index, :show]
  map.resources :items
  map.resources :users, :has_many=>:hearts

  map.root :controller=>"hearts"

end
