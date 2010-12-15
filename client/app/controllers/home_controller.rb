HomeController.class_eval do
  
  before_filter :get_latest_tweet, :only => %w{index}
  
  def index
    @events = Event.closest.limit(3)
    @latest_news_item = Section.news.pages.latest.first
    @news_items = Section.news.pages.latest.not_including(@latest_news_item).limit(2)
    @products = Product.latest.limit(3)
    @carousel_pages = Page.show_in_carousel.limit(4)
    @campaign = Section.slug(:campaigns).children.descend_by_created_at.limit(1).first
    @forum_topics = Forum.first.nil? ? [] : Forum.first.topics.descend_by_sticky.limit(3)
    @about_tinnitus_page = Page.slug("about-tinnitus")
    @professionals_section = Section.slug("for-health-professionals")
    @researchers_section = Section.slug("for-researchers")
    @policy_makers_section = Section.slug("for-policy-makers")
  end
  
  private
  def get_latest_tweet
    @latest_tweet = fetch_latest_tweets_from("britishtinnitus", 1, false, false).first
  end
  
end