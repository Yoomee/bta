Cart.class_eval do

  after_save :update_price_brackets

  private
  def update_price_brackets
    # bta_member and overseas need to be mutually-exclusive
    self.bta_member = false if overseas?
    self.overseas = false if bta_member?
    items.each do |item|
      item.update_attributes!(:bta_member => bta_member?, :overseas => overseas?)
    end
  end
  
end