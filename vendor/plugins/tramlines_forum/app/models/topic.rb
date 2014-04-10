class Topic < ActiveRecord::Base

  belongs_to :forum
  belongs_to :member
  has_many :posts, :order => "created_at", :dependent => :destroy

  has_breadcrumb_parent :forum
  accepts_nested_attributes_for :posts
  alias_attribute :author, :member

  named_scope :non_stickies, :conditions => {:sticky => false}
  named_scope :stickies, :conditions => {:sticky => true}
  named_scope :stickies_first, :order => "sticky DESC"
  named_scope :recently_posted_to_with_stickies_first, :joins => :posts, :order => "sticky DESC, max(posts.created_at) DESC", :group => "topics.id"
  named_scope :recently_posted_to, :joins => :posts, :order => "max(posts.created_at) DESC", :group => "topics.id"
  
  class << self
    
    def search(search_term) 
      topics = Topic.find :all
      res = Array.new
      for topic in topics
        s = topic.search_for search_term
        if s
          r = {'id' => topic.id, 'type' => 'topic'}.merge s
          res << r
        end
      end
      res
    end

  end

  # returns whether member has posted in the topic
  def contains_post_by?(member)
    return false if member.nil?
    posts.exists?(:member_id => member.id)
  end

  def get_last_message
    get_last_post.try(:message)
  end
  
  def get_last_post
    if !posts.empty?
      posts.last
    end
  end

  def get_last_post_created_at
    get_last_post.try(:created_at)
  end

  def get_last_post_icon
    get_last_post.try(:get_icon)
  end
  
  def get_last_post_subject
    if subject = get_last_post.try(:subject)
      if subject =~ /Re:\s*[A-Za-z]*/
        subject
      else
        "Re: #{subject}"
      end
    else
      ''
    end
  end
  
  def get_last_poster
    get_last_post.try(:get_poster)
  end
  
  def get_last_poster_time
    if post = get_last_post
      post.created_at.to_s(:short)
    end
  end
  
  def get_poster_name
    if self.member
      return self.member.full_name
    else
      return "Anonymous"
    end
  end

  def get_replies
    posts.count - 1
  end
  
  def get_subject
    posts.empty? ? '' : posts.find(:first, :order => "created_at").subject
  end
  alias_method :subject, :get_subject
  
  #returns the number of views
  def get_views
    self.views
  end
  
  #Checks whether a member is allowed to view this forum
  def is_allowed? member
    options = {:controller => 'topic', :action => 'show', :id => self.id, :member => member}
    if Permission.allowed_to? options
      true
    else
      false
    end 
  end

  #checks to see if the member is the owner of the post
  def is_owner? member
    if self.member
      return self.member == member
    else
      return false
    end
  end
 
  def is_sticky?
    self.sticky == 1
  end
  
  #checks to see if any new posts have been added that the member has not seen
  #Returns an image depending on the outcome
  def new_posts? member
    viewings = member.try(:viewings) || []
    posts = self.posts - viewings
    #new_posts?
    if posts.size > 0
      #sticky?
      if self.sticky.to_i == 1
        Post.sticky_new_post_image
      else
        Post.new_post_image
      end
    else
      #sticky?
      if self.sticky.to_i == 1
        Post.sticky_no_new_post_image
      else
        Post.no_new_post_image
      end
    end
  end
  
  #checks to see if there have been any new posts since the time given
  #returns an image depending on the outcome
  def new_posts_since time
    if self.posts
      if !self.posts.find(:all, :conditions=>["posts.created_at > ?", time]).empty?
        if self.sticky.to_i == 1
          Post.sticky_new_post_image
        else
          Post.new_post_image
        end
      else
        if self.sticky.to_i == 1
          Post.sticky_no_new_post_image
        else
          Post.no_new_post_image
        end
      end
    end
  end
  
  #notifies other posters of a reply
  def notify_others post
    BackgroundRake::call("tramlines_forum:topic:notify_others", :post_id => post.id)
    # psts = self.posts - [post]
    # psts.each do |pst|
    #   pst.notify_author post
    # end
  end

  #previews the subject
  def preview_subject
    if get_subject.length > 25
      get_subject.to(23)+".."
    else
      self.get_subject
    end
  end
  alias_method :to_s, :preview_subject
  
  
  #searches the authors of the topic for the search term. Returns and array of hashes. Advanced Search only
  def search_authors search_term
    res = Array.new
    self.posts.each do |post|
      if post.search_author(search_term)
        res << {'title'=> self.subject, 'type' => post.class.name, 'id' => post.id, 'excerpt'=>{'field'=>'author', 'value'=>post.get_poster_name}}
      end
    end
    res
  end
  
  #searches for the search term in the subject and posts of the topic
  def search_for search_term
    if self.subject && (self.subject.downcase.match search_term.downcase)
      res = {'subject' => self.subject}
      res['excerpt'] = {'field' => nil, 'value' => self.subject}
    end
    self.posts.each do |post|
      if post.search_for search_term
        res = {'subject' => post.message}
        res['excerpt'] = {'field' => nil, 'value' => post.message}
      end
    end
    return res
  end

  #searches the posts of the topic for the search term. Returns an array of hashes. Advanced Search only
  def search_posts search_term
    res = Array.new
    self.posts.each do |post|
      if post.search_for(search_term)
        res << {'title'=> self.subject, 'type' => post.class.name, 'id' => post.id, 'excerpt'=>{'field'=>'message', 'value'=>post.message}}
      end
    end
    res
  end
  
  #searches the subject only. Returns an array of hashes. Advanced Search only
  def search_subject search_term
    array = Array.new
     if self.subject.downcase.match search_term.downcase
      res = {'title' => self.subject, 'id' => self.id, 'type' => self.class.name}
      res['excerpt'] = {'field' => 'subject', 'value' => self.subject}
      array << res
    end
    array
  end

  #Records that the member has seen all the posts in the topic. 
  def viewed_by member
    if member
      posts.not_viewed_by(member).each {|p| p.viewed(member)}
    end
  end

end
