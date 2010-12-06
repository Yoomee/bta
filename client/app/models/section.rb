Section.class_eval do
  
  alias_attribute :title, :name
  
  class << self
    
    def news
      slug(:news_and_events, :name => "News & Events")
    end
    
  end
  
end