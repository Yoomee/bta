ActionController::Routing::Routes.draw do |map|

  map.resource :cart
  map.resources :cart_items
  map.resources :departments, :collection => {:map => :get} do |departments|
    departments.resources :departments
    departments.resources :products
  end
  map.resources :orders, :member => {:dispatch => :post, :cancel => :post}
  map.resources :products do |products|
    products.resources :photos, :controller => 'product_photos', :except => :destroy
  end
  map.destroy_product_photo '/product_photos/:id', :controller => 'product_photos', :action => 'destroy', :method => 'delete'
  
  map.shop '/shop', :controller => 'departments', :action => 'index'
  
end
