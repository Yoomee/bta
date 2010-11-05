SectionsController.class_eval do
  
  def show
    case @section.view
      when 'latest_stories'
        @pages_sections = @section.pages.published.latest + @section.children
        @pages_sections.extend(SortByWeightAndLatest)
        @pages_sections = @pages_sections.sort_by_weight_and_latest.paginate(:page => params[:page], :per_page => (APP_CONFIG[:latest_stories_items_per_page] || 6))
        render :action => 'latest_stories'
      when 'first_page'
        redirect_to page_path(@section.first_page) unless @section.pages.empty?
    end
    # Otherwise use show view
    @pages_sections = @section.pages.published + @section.children
    @pages_sections = @pages_sections.sort_by(&:weight).paginate(:page => params[:page], :per_page => 20)
  end
  
end

