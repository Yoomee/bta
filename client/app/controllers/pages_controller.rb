PagesController.class_eval do
  def show
    if @page.is_event?
      @breadcrumb = [Section.find_by_slug("news_and_events"), @page]
    end
  end
end