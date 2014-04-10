module TramlinesShop::ApplicationControllerExtensions
  
  def self.included(klass)
    klass.helper_method :find_existing_cart
    klass.helper_method :uses_paypal?
  end
  
  def find_cart
    cart = find_existing_cart
    return cart if cart
    cart = Cart.create!
    session[:cart_id] = cart.id
    cart
  end

  def find_existing_cart
    if cart = logged_in_member.try(:cart)
      session[:cart_id] = cart.id
      cart
    elsif cart_id = session[:cart_id]
      begin
        cart = Cart.find(session[:cart_id])
        cart.update_attribute(:member_id, logged_in_member.id) if logged_in_member && cart.member.nil?
        cart
      rescue ActiveRecord::RecordNotFound
        session.delete(:cart_id)
        find_existing_cart
      end
    end
  end
  
  def get_cart
    find_cart
  end
 
  def uses_paypal?
    APP_CONFIG[:paypal_business_email]
  end
  
 
end