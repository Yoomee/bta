Page.class_eval do
  
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
  
end