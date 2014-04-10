ActionController::Routing::Routes.draw do |map|

  map.resources :forums, :collection => {:list => :get} do |forums|
    forums.resources :topics do |topics|
      topics.resources :posts
    end
  end

  map.resources :topics do |topics|
    topics.resources :posts    
  end  
  map.resources :posts
  
  map.resources :forum_rankings
  
end