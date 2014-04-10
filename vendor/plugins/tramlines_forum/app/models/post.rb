class Post < ActiveRecord::Base

  # add_to_news_feed
  after_destroy :reduce_topic_replies_count

  cattr_reader :per_page
  @@per_page = 6
  
  attr_accessor :content_type
  attr_accessor :data

  belongs_to :member
  belongs_to :topic

  has_and_belongs_to_many :viewings, :class_name => 'Member', :join_table => 'post_viewings'
  
  named_scope :most_recent, :order => "created_at DESC"
  named_scope :since, lambda { |time| { :conditions => ["created_at > ?", time] } }
  named_scope :from_forum, lambda {|forum| {:joins => "INNER JOIN topics ON (posts.topic_id = topics.id) INNER JOIN forums ON (topics.forum_id = forums.id)", :conditions => ["forums.id = ?", forum.id]}}  
  named_scope :not_viewed_by, lambda {|member| {:conditions => ["NOT EXISTS (SELECT * FROM post_viewings WHERE post_viewings.post_id = posts.id AND post_viewings.member_id = ?)", member.id]}}

  search_attributes %w{subject message}, :autocomplete => %w{subject}

  validates_presence_of :subject, :message
  validates_uniqueness_of :file, :allow_nil => true, :message => "This file name is already in use. Please adjust it"
  
  class << self
 
    def new_post_image
      "new_post.gif"
    end
  
    def no_new_post_image
      "no_new_post.gif"
    end

    def sticky_new_post_image
      "sticky_new_post.gif"
    end
  
    def sticky_no_new_post_image
      "sticky_new_post.gif"
    end
    
    def to_s_for_search
      "Forum posts"
    end

  end

  def base_part_of(filename)
    File.basename(filename).gsub(/[^\w._-]/, '')
  end

  #Breadcrumb for the post
  def breadcrumb
    [['forums', {:controller => 'forum', :action =>'list' }], [self.forum.title, {:controller => 'forum', :action => 'show', :id => self.forum.id}], [self.topic.preview_subject, {:controller => 'topic', :action => 'show', :id => self.topic.id}]]
  end

  def file_image
    "folder_digest-a.gif"  
  end
 
  def forum
    topic ? topic.forum : nil
  end
  
  def get_icon
    if self.message_icon
      message_icon
    else
      false
    end
  end
  
  #returns poster name or "Anonymous"
  def get_poster
    self.member
  end
  
  #returns the area the poster is from
  def get_poster_area
    if self.member
      "#{self.member.region} - #{self.member.country}"
    else
      "n/a"
    end
  end
  
  #returns the date the user joined on
  def get_poster_join_date
    if self.member
      self.member.created_at.to_s(:long)
    else
      "n/a"
    end
  end
  
  def get_poster_name
    if self.member
      self.member.full_name
    else
      "Anonymous"
    end
  end

  #returns the number of posts the poster has
  def get_poster_posts
    if self.member
      self.member.posts.size
    else
      1.to_s
    end
  end
  
  def get_subject
    self.topic.get_last_post_subject
  end

  def has_file?
    if self.file
      true
    else
      false
    end
  end
    
  def is_moderator? member
    self.topic.is_moderator? member
  end

  #checks if the member is the owner
  def is_owner? member
    self.member == member
  end

  def is_permitted? member, level_required
    self.topic.is_permitted? member, level_required
  end 
 
  #notifies the author of this post that a reply (post) has been made BUT only if requested
  def notify_author post
    if self.email.to_i == 1
      Notifier.deliver_post_notification(self.member, post)
    end
  end
  
  # the page number this record will appear on
  def page_num
    num_previous_posts = topic.posts.count(:conditions => ["created_at < ?", self.created_at], :order => "created_at ASC")
    (num_previous_posts / self.class::per_page) + 1
  end
  
  def save perform_validation=true
    returning out = super(perform_validation) do
      save_data if out
    end
  end

  def save_data
    if self.data
      unless File.exists?("#{RAILS_ROOT}/public/uploads/posts")
        # Create the directory, we're gonna need it!!
        FileUtils.mkdir_p "#{RAILS_ROOT}/public/uploads/posts"
      end
      File.open("public/uploads/posts/#{self.file}", "wb") { |f| f.write(self.data) }
    end
    true    
  end

  #searches the author of the post for the search term
  def search_author search_term
    if member
      if self.member.full_name.downcase.match(search_term.downcase)
        true
      else
        false
      end
    else
      false
    end
  end
  
  #basic search, searches message for search term
  def search_for search_term
    att_val = read_attribute 'message'
    if att_val && (att_val.downcase.match search_term.downcase)
      true
    else
      false
    end
  end

  #Is the time greater than edit post time limit
  def timed_out?
    Time.now > self.created_at.advance(:minutes=>Setting.get('forum', 'time_out_time').to_i)  
  end
  
  def to_s
    subject
  end

  #Method to upload a file to a post. The original filename is stored in the db. The file is then saved to a
  #location with the file name being post<id>. This means that you can have 2 files with the same original file
  #name on the server
  def upload_file=(uploaded_file)
    if uploaded_file != ""
      self.file = base_part_of(uploaded_file.original_filename).to_s
      self.content_type = uploaded_file.content_type.chomp
      self.data = uploaded_file.read 
      self.file.to_s
    end
  end

  #records that the member has viewed the post
  def viewed member
    if member
      self.viewings << member
    end
  end
  
  private
  
  def reduce_topic_replies_count
    self.topic.replies -= 1
    self.topic.save
  end
  
end
