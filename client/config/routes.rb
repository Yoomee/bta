ActionController::Routing::Routes.draw do |map|

  map.resources :contacts, :collection => {:search => :post}
  map.resources :contact_categories
  map.resources :documents, :only => [], :collection => {:list => :get}
  
  map.directory '/directory/:id', :controller => 'contacts', :action => 'index'
  
  map.resources :searches, :controller => :search, :as => :search, :new => {:autocomplete => :get}, :collection => {:jquery_autocomplete => :get}
  
  map.sitemap '/sitemap', :controller => 'sections', :action => 'index'
  
  map.report_post '/posts/:id/report', :controller => 'posts', :action => 'report'
  
  map.forum_closed '/forum-closed', :controller => 'forums', :action => 'closed'
  
end
