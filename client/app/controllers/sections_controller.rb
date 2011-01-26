SectionsController.class_eval do
  
  def archive
    begin
      @section = Section.find params[:id]
      @month = params[:month].to_i
      @year = params[:year].to_i
      if @month.zero? || @year.zero?
        month_and_year = @section.last_month_and_year
        @month = month_and_year[0]
        @year = month_and_year[1]
      end
      if @section.slug_is(:news_and_events)
        @page_title = "News archive: #{Date::MONTHNAMES[@month]} #{@year}"
        @breadcrumb = [['Home', home_path]] + @section.breadcrumb + ["News archive"]
      else
        @page_title = "#{@section.name}: #{Date::MONTHNAMES[@month]} #{@year}"
      end
      @pages = @section.pages.published.for_month_and_year(@month, @year)
    rescue ActiveRecord::RecordNotFound
      render_404
    end
  end
  
  def show
    case @section.view
      when 'latest_stories'
        if @section.slug_is(:news_and_events)
          @pages_sections = @section.pages.published.latest.limit(18)
        else
          @pages_sections = @section.pages.published.latest + @section.children
        end
        @pages_sections.extend(SectionsController::SortByWeightAndLatest)
        @pages_sections = @pages_sections.sort_by_weight_and_latest.paginate(:page => params[:page], :per_page => (APP_CONFIG[:latest_stories_items_per_page] || 6))
        return render(:action => 'latest_stories')
      when 'first_page'
        redirect_to page_path(@section.first_page) unless @section.pages.empty?
    end
    # Otherwise use show view
    @pages_sections = @section.pages.published + @section.children
    @pages_sections = @pages_sections.sort_by(&:weight).paginate(:page => params[:page], :per_page => 20)
  end

  def show_with_events
    if @section == Section::events
      @pages_sections = @section.pages.published.all(:joins => :event, :conditions => ["events.start_at > ? ", Time.now], :order => "events.start_at").paginate(:page => params[:page], :per_page =>  20)
    else
      show_without_events
    end
  end
  alias_method_chain :show, :events
  
end

