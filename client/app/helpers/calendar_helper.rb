CalendarHelper.module_eval do
  
  # custom options for this calendar
  def event_calendar_opts
    { 
      :year => @year,
      :month => @month,
      :event_strips => @event_strips,
      :month_name_text => I18n.localize(@shown_month, :format => "%B %Y"),
      :previous_month_text => "<< " + month_link(@shown_month.last_month),
      :next_month_text => month_link(@shown_month.next_month) + " >>",
      :use_all_day => true,
      :link_to_day_action => true,
      
      :abbrev => false,
      :day_names_height => 26,
      :day_nums_height => 18,
      :event_height => 22,
      :event_margin => 5,
      :event_padding_top => 4

      # 
      # :first_day_of_week => 0,
      # :show_today => true,
      # :show_header => true,
      # :month_name_text => (Time.zone || Time).now.strftime("%B %Y"),
      # :previous_month_text => nil,
      # :next_month_text => nil,
      # :event_strips => [],
      # 
      # # it would be nice to have these in the CSS file
      # # but they are needed to perform height calculations
      # :width => nil,
      # :height => 500,
      # :day_names_height => 18,
      # :day_nums_height => 18,
      # :event_height => 18,
      # :event_margin => 1,
      # :event_padding_top => 2,
      # 
      # :use_all_day => false,
      # :use_javascript => true,
      # :link_to_day_action => false
    }
  end

  
end