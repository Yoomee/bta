CartItem.class_eval do

  attr_writer :is_donation, :donation_amount, :gift_aid, :gift_aid_today, :gift_aid_past, :gift_aid_future
  
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
      if @gift_aid && @gift_aid_today
        name = "Gift-aid donation"
      else
        name = "Non-gift-aid donation"
      end
      gift_aid_periods = [
        (@gift_aid_today ? 'T' : nil),
        (@gift_aid_past ? 'P' : nil),
        (@gift_aid_future ? 'F' : nil)
      ].compact
      unless gift_aid_periods.empty?
        name << " [#{gift_aid_periods.join('')}]"
      end
      name
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
