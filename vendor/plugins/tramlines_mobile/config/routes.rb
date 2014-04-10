ActionController::Routing::Routes.draw do |map|

  map.connect '/mobile/toggle', :controller => 'mobile', :action => 'toggle'
  
end
