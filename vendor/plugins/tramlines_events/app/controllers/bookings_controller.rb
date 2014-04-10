class BookingsController < ApplicationController

  open_action :new

  prepend_before_filter :get_event, :only => %w{create new}

  def create
    @booking = Booking.new(params[:booking])
    if @booking.save
      if @event.use_paypal?
        @booking.update_attribute(:payment_status, 'Passed to Paypal')
        redirect_to @booking.paypal_url(event_url(@event.page), paypal_notifications_url)
      else
        flash[:notice] = "Thank you for booking"
        redirect_to_waypoint
      end
    else
      render :action => 'new'
    end
  end

  def new
    @booking = Booking.new(:event => @event)
  end
  
  private
  def allowed_to?(url_options, member)
    case url_options[:action]
      when 'new', 'create'
        super(url_options, member) && @event.bookable?
      else
        super(url_options, member)
    end
  end

  def get_event
    @event = Event.find(params[:event_id] || params[:booking][:event_id])
  end
  
end
