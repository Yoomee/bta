module TramlinesRatings::RateableByMember
  
  def self.included(klass)
    klass.has_many :disliking_members, :through => :dislikings, :source => :member
    klass.has_many :dislikings, :class_name => 'Rating', :as => :rateable, :conditions => "ratings.score < 0", :dependent => :destroy
    klass.has_many :liking_members, :through => :likings, :source => :member
    klass.has_many :likings, :class_name => 'Rating', :as => :rateable, :conditions => "score > 0", :dependent => :destroy
    klass.has_many :rating_members, :through => :ratings, :source => :member
    klass.has_many :ratings, :as => :rateable, :dependent => :destroy
    klass.named_scope :top_rated, :joins => "LEFT OUTER JOIN ratings ON (ratings.rateable_id = #{klass.table_name}.id AND ratings.rateable_type = '#{klass.to_s}')", :group => "#{klass.table_name}.id", :order => "AVG(IFNULL(ratings.score, 0)) DESC"
  end
  
  def add_rating_for!(member, value)
    return false if member.nil?
    member.owned_ratings.create(:rateable => self, :score => value)
  end
  
  def average_rating
    (rating/ratings.size).to_i
  end
  
  def been_disliked?
    !dislikings.count.zero?
  end
  
  def been_liked?
    !likings.count.zero?
  end
  
  def been_rated?
    !ratings.count.zero?
  end
  
  def disliked_by?(member)
    disliking_members.exists?(:id => member.id)
  end
  
  def dislikings_count_string
    dislikings.empty? ? "" : dislikings.count
  end
  
  def likings_count_string
    likings.empty? ? "" : likings.count
  end
  
  def liked_by?(member)
    liking_members.exists?(:id => member.id)
  end
  
  def rated_by?(member)
    return false if member.nil?
    ratings.exists?(:member_id => member.id)
  end
  
  def rating
    ratings.inject(total_score = 0) do |total_score, rating|
      total_score += rating.score
    end
  end
  
  def rating_by(member)
    if member_rating = ratings.find_by_member_id(member.id)
      member_rating.score
    else
      nil
    end
  end

end
