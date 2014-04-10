class CartItemsController < ApplicationController

  expose(:cart) {get_cart}
  expose(:cart_item)
  prepend_before_filter :get_cart_item, :only => :destroy

  def allowed_to_with_cart_checking?(url_options, member)
    return false if !allowed_to_without_cart_checking?(url_options, member)
    return cart.contains_item?(@cart_item) || logged_in_member.try(:is_admin?) if url_options[:action] == 'destroy'
    true
  end
  alias_method_chain :allowed_to?, :cart_checking
        
  def create
    @cart_item = cart.items.find_or_initialize_by_product_id(params[:cart_item][:product_id])
    @cart_item.add_quantity(params[:cart_item][:quantity])
    cart.member_id ||= logged_in_member_id
    if @cart_item.save
      redirect_to cart_path
    else
      flash[:error] = @cart_item.errors.to_message
      redirect_to request.referrer
    end
  end
  
  def destroy
    @cart_item.destroy
    redirect_to cart_path
  end
  
  private
  def get_cart_item
    @cart_item = CartItem.find(params[:id])
  end
  
end