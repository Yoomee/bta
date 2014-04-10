class PaypalNotification < ActiveRecord::Base
  
  belongs_to :booking
  serialize :params

  after_create :update_booking_status
  
  private
  def update_booking_status
    booking.update_attribute(:payment_status, status)
    Notifier.deliver_new_booking_notification(booking) if status == 'Completed'
  end
  
end
