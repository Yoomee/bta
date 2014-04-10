module TramlinesRatings
  
  def self.included(klass)
    Member.send(:include, TramlinesRatings::MemberExtensions)
  end
  
end
