module EventHelper
  
  def date_description(page, format = nil)
    return "" if page.event.nil?
    format ||= :neat_date_and_time unless page.event_same_day?
    if format.blank?
      "#{page.event_start_at.to_s(:neat_date)} #{page.event_start_at.to_s(:short_time)} - #{page.event_end_at.to_s(:short_time)}"
    else
      html = "Starts: #{page.event_start_at.to_s(format)}"
      html += "<br />"
      html + "Finishes: #{page.event_end_at.to_s(format)}"
    end
  end
  
  def event_list(events, options = {})
    render('events/event_list', :events => (events ||= []), :options => options)
  end
  
  def url_for_day(date)
    day_calendar_path(:year => date.year, :month => date.month, :day => date.day)
  end
  
  def viewing_calendar?
    if controller_name=="pages"
      current_section?(Section.find_by_slug("events"))
    else  
      controller_name.in? %w{calendar bookings events}
    end
  end
  alias_method :viewing_events?, :viewing_calendar?
  
end