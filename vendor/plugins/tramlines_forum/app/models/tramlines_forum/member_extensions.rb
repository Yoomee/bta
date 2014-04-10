module TramlinesForum::MemberExtensions

  def self.included(klass)
    klass.has_many :posts
    klass.belongs_to :forum_ranking    
    klass.has_and_belongs_to_many :viewings, :class_name => 'Post', :join_table => 'post_viewings'
    klass.has_and_belongs_to_many :forums
  end

  def forum_ranking_name
    forum_ranking.try(:name) || ForumRanking.num_posts_needed_lte(posts.count).descend_by_num_posts_needed.first.try(:name)
  end

end