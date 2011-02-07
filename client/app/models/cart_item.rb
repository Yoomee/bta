CartItem.class_eval do

  attr_writer :is_donation, :donation_amount, :gift_aid
  
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
  
  def product_name_with_donations
    if @is_donation
      "#{@gift_aid ? "Gift-aid" : 'Non-gift-aid'} donation"
    else
      product_name_without_donations
    end
  end
  alias_method_chain :product_name, :donations
  
  def product_price_in_pounds
    product.send("#{price_bracket_prefix}price_in_pounds") || product.price_in_pounds
  end
  
  def product_price_in_pounds_with_donations
    if @is_donation
      @donation_amount
    else
      product_price_in_pounds_without_donations
    end
  end
  alias_method_chain :product_price_in_pounds, :donations
  
end
