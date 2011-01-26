ActionController::Routing::Routes.draw do |map|

  map.resources :contacts, :collection => {:search => :post}
  map.resources :contact_categories
  
  map.directory '/directory/:id', :controller => 'contacts', :action => 'index'
  
  map.resources :searches, :controller => :search, :as => :search, :new => {:autocomplete => :get}, :collection => {:jquery_autocomplete => :get}
  
  map.sitemap '/sitemap', :controller => 'sections', :action => 'index'
  
end
