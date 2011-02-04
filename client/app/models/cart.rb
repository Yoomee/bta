Cart.class_eval do

  after_save :update_price_brackets

  validates_each :donation_amount_in_pounds_s do |record, attr, value|
    record.errors.add attr, 'cannot be less than zero' if record.donation_amount_in_pence < 0
  end
  
  def donation_amount_in_pounds
    donation_amount_in_pence.to_f / 100
  end
  
  def donation_amount_in_pounds=(pounds)
    self.donation_amount_in_pence = pounds.to_f * 100
  end
  alias_method :donation_amount_in_pounds_s=, :donation_amount_in_pounds=

  def donation_amount_in_pounds_s
    "%.2f" % donation_amount_in_pounds
  end
  
  def donation_item
    CartItem.new(:donation => true, :amount => donation_amount_in_pounds, :gift_aid => donation_gift_aid)
  end
  
  def has_donation?
    !donation_amount_in_pence.zero?
  end
  
  def paypal_url_with_donations
    if has_donation?
      # Add the donation item
      items << donation_item
      # Get the URL
      returning paypal_url_without_donations do
        # Remove the donation item - probable never needed as the cart will be destroyed, but just in case
        items.pop
      end
    else
      paypal_url_without_donations
    end
  end
  alias_method_chain :paypal_url, :donations
  
  def total_to_pay_in_pounds
    total_in_pounds + donation_amount_in_pounds
  end
  
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
