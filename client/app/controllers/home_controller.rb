HomeController.class_eval do
  
  def index
    @events = Event.closest.limit(3)
    @latest_news_item = Section.news.pages.latest.first
    @news_items = Section.news.pages.latest.not_including(@latest_news_item).limit(2)
  end
  
end