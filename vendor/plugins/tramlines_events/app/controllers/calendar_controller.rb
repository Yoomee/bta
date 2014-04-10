class CalendarController < ApplicationController
  
  def index
    @year = (params[:year] || Date.today.year).to_i    
    @month = (params[:month] || Date.today.month).to_i
    begin
      @shown_month = Date.civil(@year, @month)
    rescue ArgumentError
      return render_404
    end
    if @category = EventCategory.find_by_id(params[:category_id])
      @event_strips = @category.events.event_strips_for_month(@shown_month)
    elsif params[:category_ids]
      @event_strips = Event.with_category_ids(params[:category_ids]).event_strips_for_month(@shown_month)
    else
      @event_strips = Event.event_strips_for_month(@shown_month)
    end
  end
  
  def day
    @year = (params[:year] || Date.today.year).to_i
    @month = (params[:month] || Date.today.month).to_i
    @day = (params[:day] || Date.today.day).to_i 
    begin
      @date = Date.civil(@year, @month, @day)
    rescue ArgumentError
      return render_404
    end
    # @events = Event.on_date(@date)
    @events = Event.events_for_date_range(@date, @date.tomorrow)
  end
  
end