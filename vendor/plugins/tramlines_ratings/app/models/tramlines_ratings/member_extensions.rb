module TramlinesRatings::MemberExtensions
  
  def self.included(klass)
    klass.has_many :owned_ratings, :class_name => "Rating"
  end
  
end