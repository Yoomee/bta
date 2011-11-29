PagesController.class_eval do

  def show
    @related_audio = Document.related_to_page(@page).audio.most_recent
    @related_documents = Document.related_to_page(@page).non_audio.most_recent
    if @page.id == 339
      @related_documents = @related_documents.sort_by {|doc| PAGE_339_WEIGHTS[doc.id] || 99}
    end
    @breadcrumb = [Section.find_by_slug("news_and_events"), @page] if @page.is_event?
    @enquiry = Enquiry.new(:form_name => 'contact', :member => logged_in_member) if @page.slug_is?("contact-us")
  end

end

PAGE_339_WEIGHTS = {
  147 => 0,
  135 => 1,
  136 => 2,
  137 => 3,
  138 => 4,
  139 => 5,
  140 => 6,
  141 => 7,
  142 => 8,
  143 => 9,
  144 => 10,
  145 => 11,
  146 => 12
}