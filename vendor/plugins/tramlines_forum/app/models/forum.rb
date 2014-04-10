class Forum < ActiveRecord::Base
  
  has_many :non_stickies, :class_name => 'Topic', :conditions => {:sticky => false}
  has_many :stickies, :class_name => 'Topic', :conditions => {:sticky => true}
  has_many :posts, :through => :topics
  has_many :topics, :class_name => 'Topic'
  has_and_belongs_to_many :members
  
  named_scope :viewable_by, lambda {|member| {:joins => "LEFT OUTER JOIN forums_members ON (forums_members.forum_id = forums.id) LEFT OUTER JOIN members ON (forums_members.member_id = members.id)", :conditions => ["forums.is_private = 0 OR members.id = ?", member.id]}}
  
  alias_attribute :to_s, :title
 
  validates_presence_of :title
  validates_uniqueness_of :title

  class << self
 
    def unique_title base
      cnt = 0
      while Forum.exists?(:title => base)
        cnt += 1
        base = "#{base}s' Forum (#{cnt})"
      end
      base
    end

  end

  def breadcrumb
    [self]
  end

  def get_last_post
    Post.from_forum(self).latest.first
  end 
  
  def new_posts? member
    posts = self.posts - member.viewings
    if posts.size > 0
      Post.new_post_image
    else
      Post.no_new_post_image
    end
  end
  
  def new_posts_since time
    if self.posts.since(time).count > 0
      Post.new_post_image
    else
      Post.no_new_post_image
    end
  end
  
  def search_description search_term
    array = Array.new
    if self.description.downcase.match search_term.downcase
      res = {'title' => self.title, 'id' => self.id, 'type' => self.class.name}
      res['excerpt'] = {'field' => 'description', 'value' => self.description}
      array << res
    end
    array
  end
  
  def viewable_by?(member)
    return true if !is_private? || member.try(:is_admin?)
    member.id ? members.exists?(member.id) : false
  end
  
end

