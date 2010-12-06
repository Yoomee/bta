PagesController.class_eval do
  def show
    @related_audio = Document.related_to_page(@page).audio
    @related_documents = Document.related_to_page(@page).non_audio
    if @page.is_event?
      @breadcrumb = [Section.find_by_slug("news_and_events"), @page]
    end
  end
end