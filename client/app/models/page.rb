Page.class_eval do
  
  belongs_to :carousel_photo, :class_name => "Photo", :autosave => true

  has_related_items :pages, :sections, :documents, :members, :photos, :links, :videos, :contacts
  
  delegate :location, :to => :event, :prefix => true
  
  def form_tabs
    out = self.class::FORM_TABS.dup
    if is_event? 
      out.delete("snippets")
      out.delete("related_items")
      out.insert(1, "location")
    else
      out
    end
  end
  
  def last_updated
    date = [publish_on, updated_at].max
    date.strftime("Last updated on %d %B %Y")
  end
end