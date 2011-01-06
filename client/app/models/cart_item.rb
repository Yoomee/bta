CartItem.class_eval do
  
  def price_bracket_prefix
    case
      when bta_member?
        'member_'
      when overseas?
        'overseas_'
      else
        ''
    end
  end
  
  def product_price_in_pounds
    product.send("#{price_bracket_prefix}price_in_pounds") || product.price_in_pounds
  end
  
end
