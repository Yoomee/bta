class BookingsReport < Report

  attr_accessor :event_id

  fields :first_name, :surname, [:date_of_birth_english, 'Date of Birth'], :gender, :phone_number, :email, [:address1, 'Address line 1'], [:address2, 'Address line 2'], :city, :postcode, :country, [:where_did_you_hear_about_the_event, 'Where did you hear about the event?'], :payment_status

  preset_params :event_id

  def event
    Event.find(event_id)
  end

  def rows
    event.bookings.map do |booking|
      Row.new(booking)
    end
  end

  def title
    "Bookings for #{event}"
  end 

  class Row < Report::Row

    def_delegators :@booking, *BookingsReport::field_names

    def initialize(booking)
      @booking = booking
    end

  end

end
