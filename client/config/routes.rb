ActionController::Routing::Routes.draw do |map|

  map.resources :contacts
  map.resources :contact_categories
  
  map.directory '/directory/:id', :controller => 'contacts', :action => 'index'
  
  map.resources :searches, :controller => :search, :as => :search, :new => {:autocomplete => :get}
  
  
  
end
