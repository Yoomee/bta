CalendarController.class_eval do
  
  def index_with_ajax
    index_without_ajax
    if request.xhr?
      render :update do |page|
        page[:sidebar_col].replace_html(:partial => 'sidebar')
        page << "setupCategoryForm();"
        page.select('.ec-calendar').replace_with(@template.event_calendar)
      end
    end
  end
  alias_method_chain :index, :ajax
  
end