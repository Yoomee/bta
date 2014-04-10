require File.dirname(__FILE__) + '/../../../../../test/test_helper'
class BookingTest < ActiveSupport::TestCase
  
  should have_db_column(:date_of_birth).of_type(:date)
  should have_db_column(:email).of_type(:string)
  should have_db_column(:first_name).of_type(:string)
  should have_db_column(:gender).of_type(:string)
  should have_db_column(:payment_status).of_type(:string)
  should have_db_column(:phone_number).of_type(:string)
  should have_db_column(:surname).of_type(:string)
  should have_db_column(:where_did_you_hear_about_the_event).of_type(:string)
  
  should belong_to(:event)
  should have_one(:location)
  
  should validate_presence_of(:address1)
  should validate_presence_of(:city)
  should validate_presence_of(:country)
  should validate_presence_of(:date_of_birth)
  should validate_presence_of(:email)
  should validate_presence_of(:first_name)
  should validate_presence_of(:gender)
  should validate_presence_of(:phone_number)
  should validate_presence_of(:postcode)
  should validate_presence_of(:surname)
  
  should allow_value('si@yoomee.com').for(:email)
  should_not allow_value('notanemailaddress.com').for(:email)
  
  should_delegate :address1, :to => :location
  should_delegate :address1=, :to => :location
  should_delegate :address2, :to => :location
  should_delegate :address2=, :to => :location
  should_delegate :city, :to => :location
  should_delegate :city=, :to => :location
  should_delegate :country, :to => :location
  should_delegate :country=, :to => :location
  should_delegate :postcode, :to => :location
  should_delegate :postcode=, :to => :location
  should_delegate :event_uses_paypal?, :to => :event, :object_method => :use_paypal?
  
end
