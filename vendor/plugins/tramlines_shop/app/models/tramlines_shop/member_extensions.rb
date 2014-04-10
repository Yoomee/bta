module TramlinesShop::MemberExtensions
  
  def self.included(klass)
    klass.has_one :cart
  end
  
end