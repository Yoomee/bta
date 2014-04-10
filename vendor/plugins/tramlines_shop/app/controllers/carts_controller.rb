class CartsController < ApplicationController

  expose(:cart) {get_cart}
  
  def update
    flash[:notice] = "Cart updated successfully" if cart.update_attributes(params[:cart])
    render :action => "show"
  end
  
  def show
  end
  
end