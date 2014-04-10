ActionController::Routing::Routes.draw do |map|

  map.calendar '/calendar/:year/:month', :controller => 'calendar', :action => 'index', :year => Time.zone.now.year, :month => Time.zone.now.month
  map.day_calendar '/calendar/day/:year/:month/:day', :controller => 'calendar', :action => 'day', :year => Time.zone.now.year, :month => Time.zone.now.month, :day => Time.zone.now.day
  
  map.new_event '/events/new/:year/:month/:day', :controller => 'pages', :action => 'new', :year => Time.zone.now.year, :month => Time.zone.now.month, :day => Time.zone.now.day, :page => {:has_event => true}
  
  map.resources :bookings
  map.resources :paypal_notifications

  map.connect '/events', :controller => 'events', :action => 'index'
  
  map.resources :events, :class => 'Page', :controller => 'pages', :requirements => {:page => {:has_event => true}} do |events|
    events.resources :bookings
  end
  
  map.resources :event_categories
  
end
