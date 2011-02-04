PagesController.class_eval do

  def show
    @related_audio = Document.related_to_page(@page).audio.most_recent
    @related_documents = Document.related_to_page(@page).non_audio.most_recent
    @breadcrumb = [Slug.find_by_name("news_and_events").model, @page] if @page.is_event?
    @enquiry = Enquiry.new(:form_name => 'contact', :member => logged_in_member) if @page.slug_is?("contact-us")
  end

end