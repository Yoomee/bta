class OrdersController < ApplicationController

  admin_only :cancel, :dispatch, :index

  after_filter :set_waypoint, :only => :new

  expose(:cart) {get_cart}
  expose(:order)
  expose(:orders) {Order.latest}
  expose(:card_details) {order.card_details}
  expose(:delivery_address) {order.delivery_address}

  attr_reader(:thank_you)
  alias_method(:thank_you?, :thank_you)
  helper_method(:thank_you?)
  
  #before_filter :get_cart
  
  def create
    case
    when uses_paypal?
      paypal_url = "#{cart.paypal_url}&return=#{order_url(:paypal)}"
      return redirect_to(paypal_url)
    when order.on_form_step?(1)
      if order.fields_valid?(%w{forename surname email})
        order.next_form_step!
      end
    when order.on_form_step?(2)
      return complete_order!
    end
    render :action => 'new'
  end

  def cancel
    order.cancel!
    redirect_to order
  end
  
  def dispatch
    order.dispatch!
    redirect_to order
  end

  def index
  end
  
  def new
  end

  def show
    @thank_you = params[:thank_you]
    empty_cart! if params[:id] == 'paypal'
  end

  private
  def complete_order!
    begin
      Order.transaction do
        order.cart = cart
        order.save!
        order.complete_payment!
      end
      Notifier.deliver_order_confirmation(order)
      empty_cart!
      return redirect_to(order, :thank_you => true)
    rescue ActiveRecord::RecordInvalid
      # Do nothing - errors will have been added to model
      puts order.errors.full_messages.inspect
    rescue CardDetails::PaymentFailedError
      @card_error_message = order.card_details_response_message
    end
    # Hack needed due to Rails not resetting id
    order.reset!
    render :action => 'new'
  end

  def empty_cart!
    cart.destroy
    session.delete(:cart_id)
  end

end
