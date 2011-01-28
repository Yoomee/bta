PagesController.class_eval do
  def show
    @related_audio = Document.related_to_page(@page).audio.most_recent
    @related_documents = Document.related_to_page(@page).non_audio.most_recent
    if @page.is_event?
      @breadcrumb = [Slug.find_by_name("news_and_events").model, @page]
    end
  end
end