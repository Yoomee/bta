class OrderLine < ActiveRecord::Base
  
  belongs_to(:order)
  belongs_to(:product)

  def amount_in_pence
    quantity * product_price_in_pence
  end
  
  def cart_item=(item)
    attrs = item.attributes.delete_if {|k, v| k.to_s == 'cart_id'}
    attrs[:product_price_in_pence] = item.product_price_in_pence
    self.attributes = attrs
  end
  
  def product_price_in_pounds
    product_price_in_pence.to_f / 100
  end
  
  def price_in_pounds
    price_in_pence.to_f / 100
  end
  
  def price_in_pence
    quantity * product_price_in_pence
  end
  
end