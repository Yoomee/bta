Product.class_eval do
  
  has_wall
  rateable_by_member

  def member_price_in_pounds
    return nil if member_price_in_pence.nil?
    member_price_in_pence.to_f / 100
  end
  
  def member_price_in_pounds=(val)
    self.member_price_in_pence = val.blank? ? nil : val * 100
  end
    
end