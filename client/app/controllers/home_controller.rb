HomeController.class_eval do
  
  before_filter :get_latest_tweet, :only => %w{index}
  
  def index
    @about_tinnitus_page = Page.slug("about_tinnitus")
    @campaign = Section.slug(:campaigns).children.show_on_front_page.descend_by_created_at.limit(1).first
    @carousel_pages = Page.show_in_carousel.all(:order => 'created_at DESC', :limit => 5)
    @events = Event.closest.limit(3)
    @forum_topics = Topic.recently_posted_to.first(3)
    @news_items = Section.latest_news(3)
    @latest_news_item = @news_items.shift
    @products = Product.latest.limit(3)
    @professionals_section = Section.slug("for-health-professionals")
    @researchers_section = Section.slug("tinnitus-research")
    @support_and_services_section = Section.slug("support-services")
  end
  
  private
  def get_latest_tweet
    @latest_tweet = fetch_latest_tweets_from("britishtinnitus", 1, false, false).first
  end
  
end
