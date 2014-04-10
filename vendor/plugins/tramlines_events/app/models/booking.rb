require 'forwardable'
class Booking < ActiveRecord::Base

  extend Forwardable

  attr_accessor :terms_and_conditions_accepted

  after_create :send_notification

  belongs_to :event
  has_location
  
  def_delegator :event, :terms_and_conditions
  def_delegator :event, :use_paypal?, :event_uses_paypal?
  def_delegators :location, :address1, :address1=, :address2, :address2=, :city, :city=, :country, :country=, :postcode, :postcode=

  def_delegator :event, :page_id, :event_page_id
 
  validates_acceptance_of :terms_and_conditions_accepted, :if => Proc.new{|booking| booking.event_has_terms_and_conditions?}
 
  validates_email_format_of :email

  validates_presence_of :address1, :city, :country, :date_of_birth, :date_of_birth_english, :email, :first_name, :gender, :phone_number, :postcode, :surname
    
  after_validation :tidy_errors
  
  def date_of_birth_english
    date_of_birth.try(:strftime, '%d/%m/%Y')
  end
  
  def date_of_birth_english=(ddmmyyy)
    begin
      self.date_of_birth = Date.strptime(ddmmyyy, '%d/%m/%Y')
    rescue ArgumentError
      if ddmmyyy.blank?
        self.date_of_birth = nil
      else
        errors.add(:date_of_birth, 'is invalid')
      end
    end
  end
 
  def event_has_terms_and_conditions?
    event.try(:has_terms_and_conditions?)
  end

  def event_name
    event.name
  end
 
  def paypal_url(return_url, notify_url)
    values = {
      :business => event.paypal_business,
      :cmd => '_cart',
      :currency_code => 'GBP',
      :upload => 1,
      :return => return_url,
      :invoice => id,
      :amount_1 => event.paypal_payment_amount,
      :item_name_1 => "#{event.name} booking",
      :quantity_1 => 1,
      :notify_url => notify_url,
      :shipping => 0,
      :no_shipping => 1
    }
    url = RAILS_ENV == 'development' ? "https://www.sandbox.paypal.com/cgi-bin/webscr?" : "https://www.paypal.com/cgi-bin/webscr?"
    url << values.map {|k, v| "#{k}=#{v}"}.join('&')
    url
  end
  
  def tidy_errors
    if errors.on(:date_of_birth)
      errors.on(:date_of_birth).each do |msg|
        errors.add(:date_of_birth_english, msg)
      end
    end
  end

  private
  def send_notification
    Notifier.deliver_new_booking_notification(self) unless event_uses_paypal?
  end

end
