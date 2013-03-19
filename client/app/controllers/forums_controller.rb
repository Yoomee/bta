ForumsController.class_eval do
  
  before_filter :get_latest_tweet, :only => %w{show}
  
  def closed
    
  end
  
  private
  def get_latest_tweet
    @latest_tweet = fetch_latest_tweets_from("britishtinnitus", 1, false, false).first
  end
  
end