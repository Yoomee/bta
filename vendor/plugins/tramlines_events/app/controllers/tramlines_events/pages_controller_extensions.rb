module TramlinesEvents
  
  module PagesControllerExtensions
    
    def self.included(klass)
      klass.before_filter :add_event_date_params, :only => 'new'
    end

    private
    def add_event_date_params
      if params[:year]
        params[:page] ||= {}
        params[:page][:event_attributes] ||= {}
        begin
          date = DateTime.civil(params[:year].to_i, params[:month].to_i, params[:day].to_i, Time.zone.now.hour)
        rescue
          date = DateTime.now
        end
        params[:page][:event_attributes].merge!(:start_at => date, :end_at => date + 1.hour)
        params[:section_id] = Section::events.id        
      end
    end
    
  end
  
end
