Product.class_eval do

  default_scope :order => "weight"
  
  has_wall
  rateable_by_member

  def member_price_in_pounds
    return nil if member_price_in_pence.nil?
    member_price_in_pence.to_f / 100
  end
  
  def member_price_in_pounds=(val)
    self.member_price_in_pence = val.blank? ? nil : val.to_f * 100
  end
  
  def overseas_price_in_pounds
    return nil if overseas_price_in_pence.nil?
    overseas_price_in_pence.to_f / 100
  end
  
  def overseas_price_in_pounds=(val)
    self.overseas_price_in_pence = val.blank? ? nil : val * 100
  end
    
end