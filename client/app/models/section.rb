Section.class_eval do
  
  alias_attribute :title, :name
  
  class << self
    
    def news
      s = Section.find_or_initialize_by_slug("news_and_events")
      s.update_attribute(:name, "News & Events") if s.new_record?
      s
    end
    
  end
  
end