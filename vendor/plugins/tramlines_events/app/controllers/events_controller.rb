class EventsController < ApplicationController
  
  def index
    @events = Event.future
  end
  
end